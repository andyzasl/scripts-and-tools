#!/bin/bash
#script to zero all free space

minfreespace=$((2*1024*1024))
dir_to_zero="/tmp"
#df -l $dir_to_zero | awk '{ print $4}' | tail -n 1

#create dir to put tmp files in
tmpdir=$(mktemp -d --tmpdir=$dir_to_zero)

echo Our tmp will be in $tmpdir
while true
do
newtmp=$(mktemp --tmpdir=$tmpdir)
dd if=/dev/zero of=$newtmp count=1024 bs=1M status=none
freespace=$(df -l $dir_to_zero | awk '{ print $4}' | tail -n 1)
echo Free=$freespace Kb
if [[ $freespace < $minfreespace ]]
    then
	echo "Target minimal space reached"
	break
fi
done
echo "Cleaning...."
echo Deleting
find $tmpdir -type f -ls -delete
rmdir $tmpdir

