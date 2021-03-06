#! /usr/bin/env bash
# Remember a directory for pop.sh
# License : GPLv3

lines_to_keep=9
data_file=~/.dir.dat
tmp_file=~/.dir.dat.$$ 
# This will throw an error when the script is invoked for the first
# time. This error can be safely ignored.
tail -"$lines_to_keep" $data_file > $tmp_file 2> /dev/null
mv $tmp_file $data_file
cur_dir=`pwd`
echo $cur_dir >> $data_file
