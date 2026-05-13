#!/usr/bin/env bash
# Reproducibly fetch the Pedreira et al. 2022 Zenodo deposit.
#
# Paper:  Pedreira, Vázquez & García 2022, Front. Microbiol. 13:758237.
# DOI:    10.3389/fmicb.2022.758237
# Zenodo: 10.5281/zenodo.5167910 (concept DOI)
#         -> resolves to 10.5281/zenodo.7732915 (version 3.0.0, the latest)
# Licence: CC-BY 4.0
#
# Usage:
#     bash fetch_data.sh [DEST_DIR]
# Default DEST_DIR: ./raw

set -euo pipefail

DEST_DIR="${1:-$(dirname "$0")/raw}"
mkdir -p "$DEST_DIR"
cd "$DEST_DIR"

# Pin to the specific version DOI so the fetch is reproducible even if a later
# v4 is uploaded. The Zenodo API exposes per-file URLs of the form
# https://zenodo.org/api/records/<id>/files/<key>/content.
RECORD_ID=7732915
API="https://zenodo.org/api/records/${RECORD_ID}/files"

FILES=(
  "A0_RUN_all.m"
  "A1_Model_Logistic.m"
  "A1_Model_Mechanistic.m"
  "A1_postprocess.m"
  "A2_Model_ODandCFUs.m"
  "A2_postprocess.m"
  "A3_SupMat.m"
  "Main_DDAC.R"
  "data_Bc.mat"
  "data_Ec.mat"
  "readme.md"
)

# Zenodo blocks plain HEAD/CURL UAs; a browser-style UA is required for GET.
UA="Mozilla/5.0 (X11; Linux x86_64) Gecko/20100101 Firefox/115.0 misspec-study/pilot"

for f in "${FILES[@]}"; do
  # Spaces / parens in filenames must be URL-encoded for the API; the listed
  # files are all simple ASCII so a literal URL is fine.
  echo "  -> $f"
  curl -sSL -A "$UA" --fail "$API/$f/content" -o "$f"
done

# The Generated_results(pre).zip file has a parenthesis in its name. Encode it
# explicitly so the script does not break under stricter shells.
echo "  -> Generated_results(pre).zip"
curl -sSL -A "$UA" --fail \
  "$API/Generated_results%28pre%29.zip/content" \
  -o "Generated_results(pre).zip"

# Optional: also save the record metadata for archival purposes.
curl -sSL -A "$UA" --fail \
  "https://zenodo.org/api/records/${RECORD_ID}" \
  -o "zenodo_record_${RECORD_ID}.json"

echo
echo "Done. Files in $DEST_DIR:"
ls -lh "$DEST_DIR"
