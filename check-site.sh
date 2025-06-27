#!/bin/ksh

URL="chat-app.jakirdev.com"
OUTPUT_FILE="result.txt"

# Clear output file
> "$OUTPUT_FILE"

i=1
while [[ $i -le 60 ]]; do
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  start=$(gdate +%s%3N)  # Use gdate instead of date
  response=$(curl -s --max-time 0.45 "$URL")
  curl_exit=$?
  end=$(gdate +%s%3N)

  response_time=$((end - start))

  if [[ $curl_exit -ne 0 || -z "$response" ]]; then
    print "$timestamp | ${response_time}ms | TIMEOUT" >> "$OUTPUT_FILE"
  else
    h1=$(print "$response" | sed -n 's:.*<h1[^>]*>\(.*\)</h1>.*:\1:p' | head -n1)
    print "$timestamp | ${response_time}ms | $h1" >> "$OUTPUT_FILE"
  fi

  sleep 0.5
  ((i = i + 1))
done

print "Finished. Results saved to $OUTPUT_FILE"
