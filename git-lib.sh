#!/bin/bash

get_git_delta() {
  local commit_id1=$1
  local commit_id2=$2

  if [ -z "$commit_id1" ] || [ -z "$commit_id2" ]; then
    echo "Error: Please provide two commit IDs as arguments."
    exit 1
  fi

  echo "Files added:"
  git diff --name-only --diff-filter=A "$commit_id1" "$commit_id2"

  echo -e "\nFiles modified:"
  git diff --name-only --diff-filter=M "$commit_id1" "$commit_id2"

  echo -e "\nFiles deleted:"
  git diff --name-only --diff-filter=D "$commit_id1" "$commit_id2"

  echo -e "\nFiles renamed:"
  git diff --name-only --diff-filter=R "$commit_id1" "$commit_id2"
}

#!/bin/bash

get_git_delta_csv() {
  local commit_id1=$1
  local commit_id2=$2

  if [ -z "$commit_id1" ] || [ -z "$commit_id2" ]; then
    echo "Error: Please provide two commit IDs as arguments."
    exit 1
  fi

  echo "Action,File"

  echo "Files added:"
  git diff --name-only --diff-filter=A "$commit_id1" "$commit_id2" | awk '{print "Added,"$0}'

  echo -e "\nFiles modified:"
  git diff --name-only --diff-filter=M "$commit_id1" "$commit_id2" | awk '{print "Modified,"$0}'

  echo -e "\nFiles deleted:"
  git diff --name-only --diff-filter=D "$commit_id1" "$commit_id2" | awk '{print "Deleted,"$0}'

  echo -e "\nFiles renamed:"
  git diff --name-only --diff-filter=R "$commit_id1" "$commit_id2" | awk '{print "Renamed,"$0}'
}


#!/bin/bash

#!/bin/bash

get_git_delta_csv2() {
  local commit_id1=$1
  local commit_id2=$2

  if [ -z "$commit_id1" ] || [ -z "$commit_id2" ] ; then
    echo "Error: Please provide 2 arguments - two commit IDs "
    exit 1
  fi

  {
    echo "Action,File"

    #echo "Files added:"
    git diff --name-only --diff-filter=A "$commit_id1" "$commit_id2" | awk '{print "Added,"$0}'

    #echo -e "\nFiles modified:"
    git diff --name-only --diff-filter=M "$commit_id1" "$commit_id2" | awk '{print "Modified,"$0}'

    #echo -e "\nFiles deleted:"
    git diff --name-only --diff-filter=D "$commit_id1" "$commit_id2" | awk '{print "Deleted,"$0}'

    #echo -e "\nFiles renamed:"
    git diff --name-only --diff-filter=R "$commit_id1" "$commit_id2" | awk '{print "Renamed,"$0}'
  } 
}




# Example usage:
get_git_delta_csv2 $1 $2 | grep $3
