#!/bin/bash

# Get the current branch
currentBranch=$(git symbolic-ref --short HEAD)

# Get the current folder
currentFolder=$(pwd)

# Get CSV files in the current folder
csvFiles=$(ls "$currentFolder"/*.csv 2>/dev/null)

# Check if any CSV files were found
if [ -z "$csvFiles" ]; then
  echo "No CSV files found in $currentFolder"
  exit 1
fi

# Iterate through each CSV file
for file in $csvFiles; do
  # Read the CSV file line by line
  while IFS=',' read -r bugId desc branch devName priority gitURL; do
    if [ "$branch" == "$currentBranch" ]; then
        # Make commit message according to CSV file format: BugID:CurrntDateTime:Branch Name:DevName:Priority:Excel Description
        git add .
        git commit -m "$bugId:$(date):$branch:$devName:$priority:$desc"
        git push
    fi
  done < "$file"
done






#add dev commit commit.sh {Developer Additional Description} 
#formt BugID:CurrntDateTime:Branch Name:DevName:Priority:Excel Description:Dev Description