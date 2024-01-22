#!/bin/bash

check_priority() {
  # Check if a CSV file is provided as an argument
  if [ -z "$1" ]; then
    echo "Error: Please provide a CSV file as an argument."
    exit 1
  fi

  # Read the CSV file and skip the header line
  { read -r; while IFS=, read -r problem package file priority line description rule_set rule; do
    # Remove double quotes from priority
    priority=$(echo "$priority" | tr -d '"')

    # Check if priority is numeric
    if [[ $priority =~ ^[0-9]+$ ]]; then
      if [ "$priority" -eq 1 ] || [ "$priority" -eq 2 ]; then
        echo "Error: Priority is $priority. Exiting with error code 2."
        exit 2
      fi
    fi
  done } < "$1"

  # If no 1 or 2 priority is found, exit with code 0
  echo "No 1 or 2 priority found. Exiting with error code 0."
  exit 0
}

function print_msg() {
    local msg=$1
    echo -e "\033[34m$_PREFIX $msg $_PREFIX\033[0m"
}


function print_err() {
    local msg=$1
    echo -e "\033[31m$_PREFIX $msg $_PREFIX\033[0m"
}



PMD_OUTPUT="/Users/mchinnappan/buildv2/pm-results.csv"

function handle_pmd_errors() {

  # Read the CSV file and skip the header line
  { read -r; while IFS=, read -r problem package file priority line description rule_set rule; do
    # Remove double quotes from priority
    priority=$(echo "$priority" | tr -d '"')

    # Check if priority is numeric
    if [[ $priority =~ ^[0-9]+$ ]]; then
      if [ "$priority" -eq 1 ] || [ "$priority" -eq 2 ]; then
        print_err "Error: Priority is $priority. Exiting with error code 2."
        return 2
      fi
    fi
  done } < "${PMD_OUTPUT}" 

  # If no 1 or 2 priority is found, exit with code 0
  print_msg "No 1 or 2 priority found. Exiting with error code 0."
  return 0
}


handle_pmd_errors

