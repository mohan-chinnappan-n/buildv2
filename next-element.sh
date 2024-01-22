extract_next_element() {
  local input_file=$1
  local output_file=$2

  if [ -z "$input_file" ] || [ -z "$output_file" ]; then
    echo "Error: Please provide two arguments - input file and output file."
    exit 1
  fi

  awk -F, -v OFS=, 'NR==1 {print $0,"NextElement"; next}
                 {gsub(/\"/,"",$2); next_element=substr($2, index($2, "/")+1); print $0, next_element}' "$input_file" > "$output_file"
}


extract_next_element $1 "$1.out.csv"

