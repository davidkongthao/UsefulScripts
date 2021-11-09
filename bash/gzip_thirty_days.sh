#!/bin/bash

thirty_days_ago=$(date -d 'now - 30 days' +%s)

for item in *; do
file_time=$(date -r $item +%s)
if (( file_time <= thirty_days_ago  )); then
        gzip $item
else
        echo "$item is not more than thirty days old."
fi
done