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
# get_git_delta_csv2 $1 $2 | grep $3


get_git_delta_csv3() {
  local commit_id1=$1
  local commit_id2=$2

  if [ -z "$commit_id1" ] || [ -z "$commit_id2" ] ; then
    echo "Error: Please provide 2 arguments - two commit IDs "
    exit 1
  fi

  {
    echo "Action,File,Type,Item"

    # Files added:
    git diff --name-status --diff-filter=A "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "A") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/") + 1)
            item = substr($2, RSTART + length(type))
          }
          print "Added," $2 "," type "," item
        }
      }'

    # Files modified:
    git diff --name-status --diff-filter=M "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "M") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/") + 1)
            item = substr($2, RSTART + length(type))
          }
          print "Modified," $2 "," type "," item
        }
      }'

    # Files deleted:
    git diff --name-status --diff-filter=D "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "D") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/") + 1)
            item = substr($2, RSTART + length(type))
          }
          print "Deleted," $2 "," type "," item
        }
      }'

    # Files renamed:
    git diff --name-status --diff-filter=R "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "R") {
          type = ""
          item = ""
          if (index($3, "/main/default/") > 0) {
            type = substr($3, index($3, "/main/default/") + length("/main/default/") + 1)
            item = substr($3, RSTART + length(type))
          }
          print "Renamed," $2 "," type "," item
        }
      }'
  }
}

# Example usage:
# get_git_delta_csv3 $1 $2 

get_git_delta_csv2() {
  local commit_id1=$1
  local commit_id2=$2

  if [ -z "$commit_id1" ] || [ -z "$commit_id2" ] ; then
    echo "Error: Please provide 2 arguments - two commit IDs "
    exit 1
  fi

  {
    echo "Action,File,Type,Item"

    # Files added:
    git diff --name-status --diff-filter=A "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "A") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/.*/, "", type)
            item = substr($2, rindex($2, "/") + 1)
          }
          print "Added," $2 "," type "," item
        }
      }'

    # Files modified:
    git diff --name-status --diff-filter=M "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "M") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/.*/, "", type)
            item = substr($2, rindex($2, "/") + 1)
          }
          print "Modified," $2 "," type "," item
        }
      }'

    # Files deleted:
    git diff --name-status --diff-filter=D "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "D") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/.*/, "", type)
            item = substr($2, rindex($2, "/") + 1)
          }
          print "Deleted," $2 "," type "," item
        }
      }'

    # Files renamed:
    git diff --name-status --diff-filter=R "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "R") {
          type = ""
          item = ""
          if (index($3, "/main/default/") > 0) {
            type = substr($3, index($3, "/main/default/") + length("/main/default/"))
            sub(/\/.*/, "", type)
            item = substr($3, rindex($3, "/") + 1)
          }
          print "Renamed," $2 "," type "," item
        }
      }'
  }
}

# Example usage:
#get_git_delta_csv4 $1 $2 | grep $3


get_git_delta_csv4() {
  local commit_id1=$1
  local commit_id2=$2

  if [ -z "$commit_id1" ] || [ -z "$commit_id2" ] ; then
    echo "Error: Please provide 2 arguments - two commit IDs "
    exit 1
  fi

  {
    echo "Action,File,Type,Item"

    # Files added:
    git diff --name-status --diff-filter=A "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "A") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]*$/, "", type)
            item = substr($2, index($2, type) + length(type) + 1)
          }
          print "Added," $2 "," type "," item
        }
      }'

    # Files modified:
    git diff --name-status --diff-filter=M "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "M") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]*$/, "", type)
            item = substr($2, index($2, type) + length(type) + 1)
          }
          print "Modified," $2 "," type "," item
        }
      }'

    # Files deleted:
    git diff --name-status --diff-filter=D "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "D") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]*$/, "", type)
            item = substr($2, index($2, type) + length(type) + 1)
          }
          print "Deleted," $2 "," type "," item
        }
      }'

    # Files renamed:
    git diff --name-status --diff-filter=R "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "R") {
          type = ""
          item = ""
          if (index($3, "/main/default/") > 0) {
            type = substr($3, index($3, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]*$/, "", type)
            item = substr($3, index($3, type) + length(type) + 1)
          }
          print "Renamed," $2 "," type "," item
        }
      }'
  }
}


get_git_delta_csv5() {
  local commit_id1=$1
  local commit_id2=$2

  if [ -z "$commit_id1" ] || [ -z "$commit_id2" ] ; then
    echo "Error: Please provide 2 arguments - two commit IDs "
    exit 1
  fi

  {
    echo "Action,File,Type,Item"

    # Files added:
    git diff --name-status --diff-filter=A "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "A") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]+$/, "", type)
            item = substr($2, index($2, type) + length(type) + 1)
          }
          print "Added," $2 "," type "," item
        }
      }'

    # Files modified:
    git diff --name-status --diff-filter=M "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "M") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]+$/, "", type)
            item = substr($2, index($2, type) + length(type) + 1)
          }
          print "Modified," $2 "," type "," item
        }
      }'

    # Files deleted:
    git diff --name-status --diff-filter=D "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "D") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]+$/, "", type)
            item = substr($2, index($2, type) + length(type) + 1)
       
          }
          print "Deleted," $2 "," type "," item
        }
      }'

    # Files renamed:
    git diff --name-status --diff-filter=R "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "R") {
          type = ""
          item = ""
          if (index($3, "/main/default/") > 0) {
            type = substr($3, index($3, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]+$/, "", type)
            item = substr($3, index($3, type) + length(type) + 1)
          }
       
          print "Renamed," $2 "," type "," item
        }
      }'
  }
}


get_git_delta_csv6() {
  local commit_id1=$1
  local commit_id2=$2

  if [ -z "$commit_id1" ] || [ -z "$commit_id2" ] ; then
    echo "Error: Please provide 2 arguments - two commit IDs "
    exit 1
  fi

  {
    echo "Action,File,Type,Item"

    # Files added:
    git diff --name-status --diff-filter=A "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "A") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]+$/, "", type)
            item = substr($2, index($2, type) + length(type) + 1)
          }
          print "Added," $2 "," type "," item
        }
      }'

    # Files modified:
    git diff --name-status --diff-filter=M "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "M") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]+$/, "", type)
            item = substr($2, index($2, type) + length(type) + 1)
          }
          print "Modified," $2 "," type "," item
        }
      }'

    # Files deleted:
    git diff --name-status --diff-filter=D "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "D") {
          type = ""
          item = ""
          if (index($2, "/main/default/") > 0) {
            type = substr($2, index($2, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]+$/, "", type)
            item = substr($2, index($2, type) + length(type) + 1)
          }
          print "Deleted," $2 "," type "," item
        }
      }'

    # Files renamed:
    git diff --name-status --diff-filter=R "$commit_id1" "$commit_id2" | awk -F'\t' '
      {
        if ($1 == "R") {
          type = ""
          item = ""
          if (index($3, "/main/default/") > 0) {
            type = substr($3, index($3, "/main/default/") + length("/main/default/"))
            sub(/\/[^\/]+$/, "", type)
            item = substr($3, index($3, type) + length(type) + 1)
          }
          print "Renamed," $2 "," type "," item
        }
      }'
  }
}





# Example usage:
get_git_delta_csv6 $1 $2 
# | csv_to_json



