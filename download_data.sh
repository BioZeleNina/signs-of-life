#!/usr/bin/env bash
# download_data.sh
# Signs of life -- course data download script
#
# Run this from inside your signs-of-life/ folder:
#   cd ~/course_data/signs-of-life
#   bash download_data.sh
#
# What this does:
#   - Downloads all course data from the GitHub release
#   - Places files in the correct directories for the Docker container
#   - Creates mission_data/ and tutorial_data/ folder structures

set -euo pipefail

REPO="BioZeleNina/signs-of-life"
RELEASE_TAG="v1.0-data"
BASE_URL="https://github.com/${REPO}/releases/download/${RELEASE_TAG}"

# ---- helpers ----
download() {
    local filename="$1"
    local dest="$2"
    echo "  Downloading ${filename}..."
    curl -fL --progress-bar \
        "${BASE_URL}/${filename}" \
        -o "${dest}/${filename}"
}

download_and_extract() {
    local archive="$1"
    local dest="$2"
    echo "  Downloading and extracting ${archive}..."
    curl -fL --progress-bar \
        "${BASE_URL}/${archive}" \
        | tar -xz -C "${dest}"
}

echo "=== Signs of life: course data download ==="
echo "Repository: ${REPO}"
echo "Release:    ${RELEASE_TAG}"
echo ""

# ---- Create directory structure ----
mkdir -p mission_data/session_01/mission
mkdir -p mission_data/population
mkdir -p mission_data/rnaseq
mkdir -p mission_data/scripts
mkdir -p tutorial_data/yeast

# ---- Session 1-2: alien scan files ----
echo "[1/9] Alien scan files (session 2)..."
download scan_01.alien.fq mission_data
download scan_02.alien.fq mission_data

# ---- Session 2: QC teaching files ----
echo "[2/9] QC teaching files (session 2)..."
download_and_extract qc_files.tar.gz mission_data

# ---- Session 3: focal individual transcoded reads ----
echo "[3/9] Focal individual reads (session 3)..."
download_and_extract focal_transcoded.tar.gz mission_data

# ---- Session 7: reference cassettes ----
echo "[4/9] Reference cassettes (session 7)..."
download reference_cassettes_I_III.fasta mission_data

# ---- Session 7: alien population reads ----
echo "[5/9] Alien population reads - 30 files (session 7)..."
download_and_extract population_alien.tar.gz mission_data

# ---- Session 5-6: alien RNA-seq reads ----
echo "[6/9] Alien RNA-seq reads (sessions 5-6)..."
download_and_extract rnaseq_alien.tar.gz mission_data

# ---- Session 7: resonance scripts ----
echo "[7/9] Resonance scripts (session 7)..."
download_and_extract resonance_scripts.tar.gz mission_data

# ---- Session 1: lore files ----
echo "[8/9] Session 1 lore files..."
download_and_extract lore_session01.tar.gz mission_data/session_01/mission

# ---- Tutorial data: yeast ----
echo "[9/9] Yeast tutorial data (all sessions)..."
download_and_extract tutorial_yeast.tar.gz tutorial_data

# ---- Verify ----
echo ""
echo "=== Verifying download ==="

ERRORS=0
check() {
    if [ -f "$1" ]; then
        printf "  OK  %s\n" "$1"
    else
        printf "  MISSING  %s\n" "$1"
        ERRORS=$((ERRORS + 1))
    fi
}

check mission_data/scan_01.alien.fq
check mission_data/scan_02.alien.fq
check mission_data/qc_bad1_adapters_R1.fq
check mission_data/qc_bad2_quality_R1.fq
check mission_data/focal_transcoded_R1.fq
check mission_data/focal_transcoded_R2.fq
check mission_data/reference_cassettes_I_III.fasta
check mission_data/population/ind_H01_typeI_R1.fq
check mission_data/rnaseq/sample_01_1.fastq
check mission_data/rnaseq/sample_04_1.fastq
check mission_data/scripts/resonance.py
check mission_data/session_01/mission/sensor_log_aurora.txt
check mission_data/session_01/mission/mission_brief.txt
check mission_data/session_01/mission/XB7734_survey_form_template.txt
check tutorial_data/yeast/scerevisiae_chrI.fasta
check tutorial_data/yeast/scerevisiae_chrI_R1.fq
check tutorial_data/yeast/scerevisiae_chrI_ont.fastq
check tutorial_data/yeast/scerevisiae_chrI_transcripts.fasta
check tutorial_data/yeast/rnaseq_fastq/sample_01_1.fastq
check tutorial_data/yeast/population/reads/yeast_A01_R1.fq

echo ""
if [ "$ERRORS" -eq 0 ]; then
    echo "All files downloaded successfully."
    echo ""
    echo "Start a session with:"
    echo ""
    echo "  Mac:     docker run -it --rm -v \"\$(pwd):/work\" biozelenina/signs-of-life:latest"
    echo "  Windows: docker run -it --rm -v \"\${PWD}:/work\" biozelenina/signs-of-life:latest"
else
    echo "WARNING: ${ERRORS} file(s) missing. Check your internet connection and try again."
    echo "If the problem persists, open an issue at https://github.com/${REPO}/issues"
    exit 1
fi
