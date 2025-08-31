#!/bin/bash

# Define variables
TEX_FILE="benjamin_liu_resume.tex"
OUTPUT_DIR="alt_versions"

# Define an array of city/state and output file name pairs
LOCATIONS=(
  "Boston, Massachusetts:benjamin_liu_resume_ma.pdf"
  "Bellevue, Washington:benjamin_liu_resume_wa.pdf"
)

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Loop through each location and compile the PDF
for LOCATION_PAIR in "${LOCATIONS[@]}"; do
  CITY_STATE="${LOCATION_PAIR%%:*}"
  OUTPUT_PDF="${LOCATION_PAIR##*:}"

  # Create a temporary file with the location replaced
  TEMP_FILE="${TEX_FILE%.tex}_temp.tex"
  sed "s/<CITY, STATE>/${CITY_STATE}/" "$TEX_FILE" > "$TEMP_FILE"

  # Compile the temporary file to PDF
  pdflatex -jobname="${OUTPUT_PDF%.pdf}" -output-directory="$OUTPUT_DIR" "$TEMP_FILE"

  # Clean up temporary file
  rm "$TEMP_FILE"

  echo "PDF saved: $OUTPUT_DIR/$OUTPUT_PDF"
done

# Delete auxiliary files generated during compilation
find "$OUTPUT_DIR" -type f \( -name "*.aux" -o -name "*.log" -o -name "*.out" \) -delete

echo "All PDFs saved to $OUTPUT_DIR"
