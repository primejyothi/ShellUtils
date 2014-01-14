#! /usr/bin/env bash
# Remember a directory for pop.sh
lines_to_keep=9
data_file=~/.dir.dat
tmp_file=~/.dir.dat.$$ 
tail -"$lines_to_keep" $data_file > $tmp_file
mv $tmp_file $data_file
cur_dir=`pwd`
echo $cur_dir >> $data_file
