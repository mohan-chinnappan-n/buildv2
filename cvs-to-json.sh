function csv_to_json() {
  # Read the CSV header to get the keys for JSON
  IFS=',' read -r -a keys
  declare -p keys | sed 's/declare -a/keys=/' > /dev/null

  # Convert CSV to JSON
  awk -v keys="${keys[*]}" 'BEGIN { FS=","; OFS=","; ORS="" } {
    n = split(keys, fields);
    if (NR > 1) {
      print "{";
      for (i = 1; i <= NF; i++) {
        printf "  \"%s\": \"%s\"", fields[i], $i;
        if (i < NF) {
          print ",";
        } else {
          print "";
        }
      }
      print "}";
      if (NR < NR-1) {
        print ",";
      }
    }
  }' | sed '$!s/$/,/' | awk 'BEGIN {print "["} {print} END {print "]"}'
}

csv_to_json