#!/bin/bash

# Start date: same day last year
start_date=$(date -d "last year" +%Y-%m-%d)

# Number of days to loop (120 days)
no_of_days=120

# Create the file if it doesn't exist
touch green.txt

# Function to increment date
increment_date() {
    date -d "$1 + 1 day" +%Y-%m-%d
}

# Loop through each day for 120 days from the start date
current_date="$start_date"
for ((i=0; i<$no_of_days; i++)); do
    # Get the day of the week (1=Monday, 7=Sunday)
    day_of_week=$(date -d "$current_date" +%u)
    
    # Skip some days randomly (e.g., about 2-4 days per month)
    skip_day=$((RANDOM % 30))
    
    if ((skip_day < 3)); then
        echo "Skipping $current_date"
        current_date=$(increment_date "$current_date")
        continue
    fi

    # Weekend logic: more commits on weekends (Saturday/Sunday)
    if ((day_of_week == 6 || day_of_week == 7)); then
        commits_today=$((RANDOM % 11 + 5))  # More commits on weekends (5-15)
    else
        commits_today=$((RANDOM % 5))  # Fewer commits on weekdays (0-4)
    fi

    # Only commit if commits_today > 0
    if (( commits_today > 0 )); then
        for ((j=0; j<$commits_today; j++))
        do
            echo "$current_date Commit #$j" >> green.txt
            git add green.txt
            GIT_AUTHOR_DATE="$current_date" GIT_COMMITTER_DATE="$current_date" git commit -m "Commit on $current_date #$j"
        done
    fi

    # Increment the date by 1 day
    current_date=$(increment_date "$current_date")
done

# Push the commits to the main branch
git push origin main

echo "✅ Done creating randomized commits for $start_date with a focus on weekends and skipped days, and pushed to main!"
