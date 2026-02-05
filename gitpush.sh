#!/bin/bash
git add .
echo "Enter your commit message:"
read -r commit_message
if [ -z "$commit_message" ]; then
  commit_message="New Message: $(date)"
  echo "No message entered, using default."
fi
git commit -m "$commit_message"
git push