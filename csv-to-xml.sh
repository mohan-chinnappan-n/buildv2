#!/bin/bash

csv_file="/tmp/output.csv"
xml_file="/tmp/output.xml"

# Function to generate XML content for a type and its items
generate_xml_content() {
    local type=$1
    shift
    echo "    <types>"
    while [ $# -gt 0 ]; do
        echo "        <members>$1</members>"
        shift
    done
    echo "        <name>$type</name>"
    echo "    </types>"
}

# Function to read CSV file and generate XML file
read_csv_and_generate_xml() {
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    echo "<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">"
    echo "    <version>58.0</version>"

    current_type=""
    current_items=()

    # Skip the header line

    while IFS=, read -r action file type item; do
        if [ "$type" != "$current_type" ]; then
            # Output previous type and its items
            if [ -n "$current_type" ]; then
                generate_xml_content "$current_type" "${current_items[@]}"
            fi

            # Start a new type
            current_type="$type"
            current_items=()
        fi

        # Add item to the current type
        current_items+=("$item")
    done < "$csv_file"

    # Output the last type and its items
    if [ -n "$current_type" ]; then
        generate_xml_content "$current_type" "${current_items[@]}"
    fi

    echo "</Package>"
}

# Run the function
read_csv_and_generate_xml > "$xml_file"

echo "XML file generated: $xml_file"
