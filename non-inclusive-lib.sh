
function search_non_inclusive_words() {
    start_time=$(date +%s.%N)  # Record start time
    folder_path="$1"
    non_inclusive_words=("dummy" "Blacklist" "whitelist")  # Add your non-inclusive words here
    excluded_extensions=("css" "pdf" "lwr_lwc" "wdash")

    # Use grep with -r for recursive search
    grep_options="--recursive --ignore-case --with-filename --line-number"

    # Iterate over non-inclusive words
    for nword in "${non_inclusive_words[@]}"; do
        # Combine grep patterns for excluded extensions
        exclude_patterns=$(printf -- "--exclude=*.%s " "${excluded_extensions[@]}")
        
        # Use grep directly with multiple patterns
        grep $grep_options $exclude_patterns "$nword" "$folder_path"/* 2>/dev/null |
            while read -r line; do
                # Print the result
                echo "$line"
            done
    done

    end_time=$(date +%s.%N)  # Record end time
    time_taken=$(echo "$end_time - $start_time" | bc)  # Calculate time taken
    echo "Time taken for search_non_inclusive_words: $time_taken seconds"
}



search_non_inclusive_words2() {
    start_time=$(date +%s.%N)  # Record start time
    folder_path="$1"
    non_inclusive_words=("dummy"  "Blacklist" "whitelist"  )  # Add your non-inclusive words here
    excluded_extensions=("css" "pdf" "lwr_lwc" "wdash") 
    find "$folder_path" -type f -name "*" | while read -r file; do
        #echo $file
        # Extract the file extension
        file_extension="${file##*.}"
        # echo "$file_extension"
        # Check if the file extension is not in the excluded list
        if [[ ! " ${excluded_extensions[@]} " =~ " $file_extension " ]]; then
            # Check if the file is a binary file
            if ! file -b "$file" | grep -q "text"; then
                        continue  # Skip binary files
            fi

                for nword in "${non_inclusive_words[@]}"; do
                    grep -n -i  "$nword" "$file" | while read -r line; do
                                # Print the result
                                echo "File: $file, $line"
                    done
                done
        fi

      
    done
    end_time=$(date +%s.%N)  # Record end time
    time_taken=$(echo "$end_time - $start_time" | bc)  # Calculate time taken
    echo "Time taken: $time_taken seconds"
}

search_non_inclusive_words . 