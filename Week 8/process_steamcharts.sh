#!/bin/bash
# Tyler Miller
# Turn the Steam Charts HTML scrape into one CSV row per game.
# Usage: ./process_steamcharts.sh [input file] [output file]
# Example: ./process_steamcharts.sh steamcharts_raw.txt steamcharts.csv

# Header for spreadsheet
echo "id,name,peak-concurrent,player-hours"

# Keep id, title (next line), peak, and hours
cat "${1:-steamcharts_raw.txt}" |
grep -E 'href="/app/|peak-concurrent|player-hours' -A1 |
grep -v '^--$' |
while read line; do
    # Find the game ID
    echo "$line" | grep -q 'href="/app/' && id=$(echo "$line" | grep -oE '[0-9]+' | tail -1)
    # Find peak number of concurrent players
    echo "$line" | grep -q 'peak-concurrent' && peak=$(echo "$line" | grep -oE '[0-9]+' | tail -1)
    # Find hours played then print the finished row
    echo "$line" | grep -q 'player-hours' && hours=$(echo "$line" | grep -oE '[0-9]+' | tail -1) && echo "$id,$name,$peak,$hours"
    # line after href is the game name
    echo "$line" | grep -q '<' || name=$line
done
