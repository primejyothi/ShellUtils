#! /usr/bin/env bash
# Search for a string in epub files listed in a file and prints the names
# of the epub files that contain the search string.
# primejyothi at gmail dot com 20140118
# License : GPLv3

if [[ "$#" -ne 2 ]]
then
	echo "Usage `basename $0` epubListFile SearchString"
	exit 2
fi

if [[ ! -r $1 ]]
then
	echo "Unable to read input file $1"
	exit 1
fi

while read i 
do
	unzip -c "$i" > j.txt
	grep -iq "$2" j.txt

	retVal=$?
	if [[ "${retVal}" -eq 0 ]]
	then
		echo $i
	fi

	rm -f j.txt
done < $1
exit 0
