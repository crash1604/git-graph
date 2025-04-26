#!/bin/bash

# Start date: 1 year ago, on Sunday
start_date=$(date -d "last year last sunday" +%Y-%m-%d)

# Days to commit (pixel positions)
pixels=(
  # Example: (week day)
  "0 0" "0 2" "0 4" "0 6"
  "1 0" "1 2" "1 4" "1 6"
  "2 0" "2 1" "2 2" "2 3" "2 4" "2 5" "2 6"
  "3 0" "3 2" "3 4" "3 6"
  "4 0" "4 2" "4 4" "4 6"
)

for pixel in "${pixels[@]}"; do
  week=$(echo $pixel | cut -d' ' -f1)
  day=$(echo $pixel | cut -d' ' -f2)
  
  # Calculate date
  commit_date=$(date -d "$start_date +$((week * 7 + day)) days" "+%Y-%m-%dT12:00:00")
  
  # Make a fake commit
  echo "$commit_date Hello pixel" >> README.md
  git add README.md
  GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" git commit -m "Pixel at week $week day $day"
done
