#! /usr/bin/env bash

# Create the lyrics file for mpd from the current song's id3 tags.
# primejyothi@gmail.com 2013-12-31
# Require mpc and exiftool
# 

if [[ "$1" = "all" ]]
then
	stop=0	
else
	stop=1
fi

# Directory where lyrics will be stored.
lyricsDir=/data2/MiscData/Music/Lyrics

# mpd Music directory
musicDir=/data2/MiscData/Music/Organize/

# Set the mpd host.
export MPD_HOST=127.0.0.1

while :
do
	# Find current song's file name
	if [[ "$stop" -eq 1 ]]
	then
		# Find lyrics for current song 
		current=`mpc -f "%file%" current`
	else
		# Find lyrics for the next song, need to wait
		current=`mpc -f "%file%" current --wait`
	fi

	# Full path
	fileName=${musicDir}/${current}

	exiftool "${fileName}" |grep "Lyrics" | awk -F": " '{print $2}' | tr -s '\.\.' '\n' > /tmp/mpd.lyrics
	exiftool -b -T -Picture "${fileName}" > /tmp/mpd.jpg

	lines=`wc -l < /tmp/mpd.lyrics`
	if [[ "$lines" -gt 5 ]]
	then
		echo "${fileName}"
		cat /tmp/mpd.lyrics
		lyricsFileName=`mpc -f "%artist% - %title%" current`
		mv /tmp/mpd.lyrics "${lyricsDir}/${lyricsFileName}.txt"
	else
		echo "Lyrics not found : ${fileName}"
	fi

	if [[ "$stop" -eq 1 ]]
	then
		break
	fi
done
