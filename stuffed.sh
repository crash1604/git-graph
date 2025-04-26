#!/bin/bash

# Start date: April 1, 2024
start_date="2024-04-01"
# End date: September 30, 2024
end_date="2024-09-30"

# Create the file if it doesn't exist
touch green.txt

# Loop through each day between start and end date
current_date="$start_date"
while [[ "$current_date" < "$end_date" ]]; do
    # Get the day of the week (1=Monday, 7=Sunday)
    day_of_week=$(date -d "$current_date" +%u)
    
    # Skip some days randomly (e.g., about 2-4 days per month)
    skip_day=$((RANDOM % 30))
    
    if ((skip_day < 3)); then
        echo "Skipping $current_date"
        current_date=$(date -I -d "$current_date +1 day")  # Use ISO format for the date
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

    # Move to the next day
    current_date=$(date -I -d "$current_date +1 day")  # Use ISO format to increment the date
done

# Push the commits to the main branch
git push origin main

echo "✅ Done creating randomized commits for April 2024 to September 2024 with weekend focus and skipped days, and pushed to main!"
