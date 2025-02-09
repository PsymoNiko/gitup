#!/bin/bash
git status

echo "Enter your commit message:"
read commit_message

if [ -z "$commit_message" ]; then
    echo "Error: Commit message cannot be empty."
    exit 1
fi

git add .

git commit -m "$commit_message"

current_branch=$(git branch --show-current)

if [ -z "$current_branch" ]; then
    echo "Error: Could not determine the current branch."
    exit 1
fi

echo "Pushing changes to branch: $current_branch"
git push origin "$current_branch"
