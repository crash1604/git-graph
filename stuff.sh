#!/bin/bash

# Start from 2 years ago
start_date=$(date -d "2 years ago" +%Y-%m-%d)

# How many days (approx 2 years)
days=730

# Create the file if it doesn't exist
touch green.txt

# Loop through each day
for ((i=0; i<$days; i++))
do
    # Get the day of the week (0=Sunday, 6=Saturday)
    day_of_week=$(date -d "$start_date +$i days" +%u)

    # Weekend logic: reduce commits on weekends (0 or 6)
    if ((day_of_week == 6 || day_of_week == 7)); then
        commits_today=$((RANDOM % 5))  # Fewer commits on weekends (0-4)
    else
        commits_today=$((RANDOM % 11))  # More commits on weekdays (0-10)
    fi

    # Only commit if commits_today > 0
    if (( commits_today > 0 )); then
        commit_date=$(date -d "$start_date +$i days" "+%Y-%m-%dT12:00:00")

        for ((j=0; j<$commits_today; j++))
        do
            echo "$commit_date Commit #$j" >> green.txt
            git add green.txt
            GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" git commit -m "Commit on $commit_date #$j"
        done
    fi
done

# Push the commits to the main branch
git push origin main

echo "✅ Done creating randomized commits for 2 years with weekend logic, and pushed to main!"
