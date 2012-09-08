#!/bin/sh

suse_version=`lsb_release -r|cut -f 2`
mkdir -p temp
for file in `ls *.repo`
do
sed "s/\$version/$suse_version/" $file > temp/$file
done


