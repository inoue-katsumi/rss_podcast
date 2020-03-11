#!/usr/bin/env bash
# Be careful not to abuse the podcast server.
# Original code can be found at https://mim.mbirgin.com/?c=posts&id=115
#
# # Replace with your podcast feed.
# rss="https://newrustacean.com/feed.xml"
rss=$1

raw=$(curl -s "$rss" | sed 's|xmlns=".*"||g')
count=$(echo $raw | xmllint --xpath "count(//rss/channel/item)" -)

# Start from oldest one. This can be reversed.
# for (( c=$count; c>=1; c-- ))
# Start from newest one. This can be reversed. Enable above 2 lines.
for (( c=1; c<=$count; c++ ))
do
  #echo $raw | xmllint --xpath "/descendant::item[$c]" -
  title=$(echo $raw | xmllint --xpath "(//rss/channel/item/title/text())[$c]" - )
  murl=$(echo $raw | xmllint --xpath "string((//rss/channel/item/enclosure)[$c]/@url)" - )
  seq=$(printf "%03d" $((count-c)))
  echo "$seq: $title : $murl"

  if [ -z "$2" ]; then
    # Use default filenames.
    # TODO: Check if file exists. But this isn't easy.
    curl -O --silent --location $murl
  else
    # Use short filenames. mp3 filenames tend to be long.
    # TODO: If file exists, exit the loop.
    curl --silent --location $murl > $2$seq.mp3
  fi
done
