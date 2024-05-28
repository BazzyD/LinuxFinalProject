#!/bin/bash

# Check if there is a Developer Additional Description
devDesc=""
if [ $# -ge 1 ]; then
    devDesc="${*:1}"
fi

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

            
            
            # Create commit message
            if [ -z "$devDesc" ]; then
                commitMessage+="$bugId:$(date):$branch:$devName:$priority:$desc \t"
            else
                commitMessage+="$bugId:$(date):$branch:$devName:$priority:$desc:$devDesc \t"
            fi
           
        fi
    done < "$file"
     # Stage changes
            git add .
            # Commit the changes
            git commit -m "$commitMessage"
            gitURL="${gitURL//[[:space:]]/}" #clean the url
            # Push the changes
            git push "$gitURL" "$currentBranch"
            
            # Check if the push was successful
            if [ $? -ne 0 ]; then
                echo "Failed to push changes to $gitURL"
                exit 1
            else
                echo "Changes pushed successfully to $gitURL"
            fi
done