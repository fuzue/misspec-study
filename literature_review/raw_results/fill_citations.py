"""
Re-fill citation counts for prior-art TSV using Semantic Scholar API with throttled
retries; fall back to OpenAlex on rate-limit failures.

Run: python fill_citations.py

Updates 03_prior_art_calibration.tsv in place (preserves original as .bak).
"""
import csv
import json
import re
import shutil
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

TSV_PATH = Path("03_prior_art_calibration.tsv")
BAK_PATH = Path("03_prior_art_calibration.tsv.bak")

S2_HDR = {"User-Agent": "MisspecStudy-litreview/0.1"}
OA_HDR = {"User-Agent": "MisspecStudy-litreview/0.1 (mailto:edgar@fuzue.tech)"}


def get_url(url: str, headers: dict, timeout: int = 30):
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.status, r.read().decode("utf-8")


def s2_by_doi(doi: str):
    """Semantic Scholar; raise on rate-limit so caller can back off."""
    encoded = urllib.parse.quote(doi, safe="")
    url = f"https://api.semanticscholar.org/graph/v1/paper/DOI:{encoded}?fields=citationCount,title,year"
    try:
        status, body = get_url(url, S2_HDR, timeout=20)
    except urllib.error.HTTPError as e:
        if e.code == 429:
            raise RuntimeError("s2_rate_limited")
        return None
    except Exception:
        return None
    if status == 200:
        data = json.loads(body)
        return data.get("citationCount")
    return None


def oa_by_doi(doi: str):
    """OpenAlex fallback — no auth, generous rate limits, mailto in UA for polite-pool."""
    encoded = urllib.parse.quote(doi, safe="")
    url = f"https://api.openalex.org/works/doi:{encoded}"
    try:
        status, body = get_url(url, OA_HDR, timeout=20)
    except Exception:
        return None
    if status == 200:
        data = json.loads(body)
        return data.get("cited_by_count")
    return None


def main():
    if not TSV_PATH.exists():
        sys.exit(f"missing {TSV_PATH}")
    if not BAK_PATH.exists():
        shutil.copy(TSV_PATH, BAK_PATH)
    with TSV_PATH.open() as f:
        reader = csv.DictReader(f, delimiter="\t")
        rows = list(reader)
        fieldnames = reader.fieldnames

    s2_ok = s2_fail = oa_ok = skipped = 0
    s2_cooldown_until = 0.0
    for i, r in enumerate(rows):
        cc = (r.get("citation_count") or "").strip()
        if cc and cc != "NA":
            skipped += 1
            continue
        doi = (r.get("doi") or "").strip()
        if not doi or doi.startswith("ISBN") or doi.startswith("arXiv"):
            # ISBN / arXiv DOIs: try OpenAlex with the raw arXiv id; skip ISBNs
            if doi.startswith("arXiv"):
                ax = doi.replace("arXiv:", "").strip()
                try:
                    encoded = urllib.parse.quote(f"https://arxiv.org/abs/{ax}", safe="")
                    url = f"https://api.openalex.org/works/{urllib.parse.quote('doi:10.48550/arXiv.' + ax, safe='')}"
                    _, body = get_url(url, OA_HDR, timeout=20)
                    data = json.loads(body)
                    if data.get("cited_by_count") is not None:
                        r["citation_count"] = str(data["cited_by_count"])
                        oa_ok += 1
                        print(f"[{i+1:2d}] arXiv {ax}: {data['cited_by_count']} (OpenAlex)")
                        time.sleep(0.4)
                        continue
                except Exception:
                    pass
            print(f"[{i+1:2d}] skipping (no DOI / ISBN): {r.get('first_author','?')} {r.get('year','?')}")
            continue

        # Try Semantic Scholar first if we're past any cooldown
        cc_val = None
        if time.time() >= s2_cooldown_until:
            try:
                cc_val = s2_by_doi(doi)
            except RuntimeError:
                # Rate-limited — back off for 60s and route through OpenAlex meanwhile
                s2_cooldown_until = time.time() + 60
                print(f"[{i+1:2d}] S2 rate-limited; cooling down 60s, using OpenAlex")
                cc_val = None
        # If S2 failed or we're in cooldown, try OpenAlex
        if cc_val is None:
            cc_val = oa_by_doi(doi)
            if cc_val is not None:
                oa_ok += 1
                src = "OpenAlex"
            else:
                s2_fail += 1
                src = "FAILED"
                print(f"[{i+1:2d}] FAILED: {doi}")
        else:
            s2_ok += 1
            src = "S2"

        if cc_val is not None:
            r["citation_count"] = str(cc_val)
            print(f"[{i+1:2d}] {doi}: {cc_val} ({src})")
        time.sleep(1.1 if src == "S2" else 0.5)

    with TSV_PATH.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, delimiter="\t")
        writer.writeheader()
        for r in rows:
            writer.writerow(r)

    print(f"\nDone. S2 ok={s2_ok}, OA ok={oa_ok}, fail={s2_fail}, skipped={skipped}, total={len(rows)}")


if __name__ == "__main__":
    main()
