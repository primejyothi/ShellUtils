#! /usr/bin/env bash
# cd to the selected directory. Need to be executed from the current shell.
# License : GPLv3

lines_to_keep=9
data_file=~/.dir.dat
tail -"$lines_to_keep" $data_file |nl
echo -e "Choice please : " \\c
read choice
case "$choice" in
[0-9]*)
	;;
*)
	echo "Invalid choice"
	return 0
	;;
esac
dest_dir=`tail -"$lines_to_keep" $data_file | head -$choice |tail -1`
cd $dest_dir
