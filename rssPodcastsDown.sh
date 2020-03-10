#!/usr/bin/env bash
# Original code can be found at https://mim.mbirgin.com/?c=posts&id=115
#
# Replace with your podcast feed.
rss="https://newrustacean.com/feed.xml"

raw=$(curl -s "$rss" | sed 's|xmlns=".*"||g')
count=$(echo $raw | xmllint --xpath "count(//rss/channel/item)" -)
for (( c=$count; c>=1; c-- ))
do
  #echo $raw | xmllint --xpath "/descendant::item[$c]" -
  title=$(echo $raw | xmllint --xpath "(//rss/channel/item/title/text())[$c]" - )
  murl=$(echo $raw | xmllint --xpath "string((//rss/channel/item/enclosure)[$c]/@url)" - )
  seq=$(printf "%03d" $((count-c)))
  echo "$seq: $title : $murl"

  # Use default filenames.
  # curl -O --silent --location $murl
  # Use appropriate filename if you don't prefer.
  curl --silent --location $murl > rust$seq.mp3
done
