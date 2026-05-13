"""
Re-query Semantic Scholar (with backoff) for additional prior-art that may not have
been captured in the original 03 axis run. Outputs candidate hits to
`03_extra_candidates.tsv` for human review/merge.

Queries focus on the gaps the first run had to back off from due to rate-limiting:
- Growth-curve specific calibration / coverage
- Bayesian growth curve with credible intervals
- Recent (2022-2026) misspecification / coverage work
- Pareto-k diagnostics applied to biological ODEs
"""
import csv
import json
import re
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

OUT = Path("03_extra_candidates.tsv")
S2_HDR = {"User-Agent": "MisspecStudy-litreview/0.1"}

QUERIES = [
    ("coverage probability nonlinear regression growth curve", 20),
    ("Bayesian credible interval Gompertz Baranyi microbial", 20),
    ("calibration confidence interval growth model bacterial", 20),
    ("PSIS-LOO Pareto-k biological ODE", 15),
    ("simulation based calibration biological model", 15),
    ("hierarchical Bayesian growth rate microbial replicate", 15),
    ("model misspecification credible interval frequentist coverage", 15),
    ("profile likelihood growth curve identifiability", 15),
    ("safe Bayes calibration misspecification", 10),
    ("posterior predictive check growth curve fit", 10),
    ("uncertainty propagation predictive microbiology Bayesian", 15),
    ("bootstrap calibration nonlinear regression coverage", 15),
]


def get_url(url, headers, timeout=30):
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.status, r.read().decode("utf-8")


def s2_search(query, limit=20, year_min=2015):
    enc = urllib.parse.quote(query, safe="")
    url = (f"https://api.semanticscholar.org/graph/v1/paper/search"
           f"?query={enc}"
           f"&fields=title,year,citationCount,authors,abstract,externalIds,journal"
           f"&limit={limit}")
    backoff = 5
    for attempt in range(4):
        try:
            status, body = get_url(url, S2_HDR, timeout=30)
            if status == 200:
                return json.loads(body).get("data", [])
        except urllib.error.HTTPError as e:
            if e.code == 429:
                print(f"  rate-limited, sleeping {backoff}s")
                time.sleep(backoff)
                backoff *= 2
                continue
            return []
        except Exception as ex:
            print(f"  error: {ex}")
            return []
    return []


def main():
    seen = set()
    rows = []
    for q, lim in QUERIES:
        print(f"\nQuery: {q!r} (limit {lim})")
        results = s2_search(q, limit=lim)
        print(f"  got {len(results)} candidates")
        for r in results:
            year = r.get("year") or 0
            if year and int(year) < 2015:
                continue
            ids = r.get("externalIds") or {}
            doi = ids.get("DOI") or ids.get("ArXiv") or r.get("paperId")
            if not doi or doi in seen:
                continue
            seen.add(doi)
            authors = r.get("authors") or []
            first = authors[0]["name"] if authors else "?"
            journal_obj = r.get("journal") or {}
            jname = (journal_obj.get("name") if isinstance(journal_obj, dict) else "") or ""
            rows.append({
                "query": q,
                "doi_or_id": doi,
                "year": year,
                "first_author": first,
                "title": (r.get("title") or "")[:200],
                "journal": jname[:80],
                "citation_count": r.get("citationCount") or 0,
                "abstract_snippet": (r.get("abstract") or "")[:300].replace("\n", " "),
            })
        time.sleep(2.0)  # generous gap between queries

    rows.sort(key=lambda x: x["citation_count"], reverse=True)
    with OUT.open("w", newline="") as f:
        fields = ["query", "doi_or_id", "year", "first_author", "title", "journal",
                  "citation_count", "abstract_snippet"]
        w = csv.DictWriter(f, fieldnames=fields, delimiter="\t")
        w.writeheader()
        for r in rows:
            w.writerow(r)
    print(f"\nWrote {len(rows)} unique candidates → {OUT}")


if __name__ == "__main__":
    main()
