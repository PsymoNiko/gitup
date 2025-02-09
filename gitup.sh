#!/bin/bash

# Display the current status of the repository
git status

# Get the list of modified files
modified_files=$(git ls-files --modified)

# Check if there are any modified files
if [ -z "$modified_files" ]; then
    echo "No modified files to commit."
    exit 0
fi

# Variable to store a global commit message
global_commit_message=""

# Iterate over each modified file and commit separately
for file in $modified_files; do
    # If a global commit message exists, use it
    if [ -n "$global_commit_message" ]; then
        commit_message="$global_commit_message"
        echo "Using global commit message for '$file'."
    else
        # Ask for a commit message
        echo "Enter commit message for '$file':"
        read commit_message

        # If the commit message starts with "!", use it for all files
        if [[ "$commit_message" == "!"* ]]; then
            global_commit_message="${commit_message:1}"  # Remove "!" from the beginning
            commit_message="$global_commit_message"
            echo "Global commit message set: $global_commit_message"
        fi
    fi

    # Check if a commit message was provided
    if [ -z "$commit_message" ]; then
        echo "Error: Commit message cannot be empty. Skipping '$file'."
        continue
    fi

    # Add the file to staging
    git add "$file"

    # Commit the file with the provided message
    git commit -m "$commit_message"
done

# Get the current branch name
current_branch=$(git branch --show-current)

# Check if the current branch was found
if [ -z "$current_branch" ]; then
    echo "Error: Could not determine the current branch."
    exit 1
fi

# Push all committed changes to the current branch
echo "Pushing changes to branch: $current_branch"
git push origin "$current_branch"

