import os
import time
import argparse

def search_non_inclusive_words(folder_path, non_inclusive_words, excluded_extensions):
    start_time = time.time()

    # Find all text files (excluding specified file extensions) in the given folder and its sub-folders
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            file_path = os.path.join(root, file)

            # Extract the file extension
            file_extension = file.split('.')[-1]

            # Check if the file extension is not in the excluded list
            if file_extension not in excluded_extensions:
                # Check if the file is a binary file
                if not file_is_text(file_path):
                    continue  # Skip binary files

                # Iterate through each non-inclusive word
                for word in non_inclusive_words:
                    # Search for the non-inclusive word in the file and print the result
                    with open(file_path, 'r', errors='ignore') as f:
                        for line_number, line in enumerate(f, start=1):
                            if word in line:
                                print(f"File: {file_path}, Line: {line_number}, Word: {word}")

    end_time = time.time()
    time_taken = end_time - start_time
    print(f"Time taken: {time_taken:.2f} seconds")

def file_is_text(file_path):
    try:
        with open(file_path, 'rt', encoding='utf-8', errors='ignore') as f:
            f.read()
        return True
    except Exception:
        return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Search for non-inclusive words in text files.")
    parser.add_argument("--folder_path", required=True, help="Path to the folder to search.")
    parser.add_argument("--non_inclusive_words", required=True, nargs="+", help="List of non-inclusive words.")
    parser.add_argument("--excluded_extensions", required=True, nargs="+", help="List of excluded file extensions.")

    args = parser.parse_args()

    search_non_inclusive_words(args.folder_path, args.non_inclusive_words, args.excluded_extensions)

# python ~/buildv2/non-inclusive-lib2.py --folder_path ../default --non_inclusive_words dummy blacklist whitelist --excluded_extensions pdf css 
