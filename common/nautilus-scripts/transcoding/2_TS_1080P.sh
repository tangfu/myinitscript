#!/bin/sh
#
#
num=$#
for((i=1;$i <= $num;))
do
	n=\$$i
	file=`eval echo $n`
	file=`pwd`/$file

	if [ -f /usr/bin/mencoder ];then
		mencoder -oac lavc -ovc lavc -of lavf -lavfopts format=mpegts -vf scale=1920:1080,harddup -srate 48000 -af lavcresample=48000 -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=8000:keyint=15:vstrict=0:aspect=16/9:acodec=mp2:abitrate=224 -ofps 25 -o "${file}.ts" "$file"
	else if [ -f /usr/bin/ffmpeg ];then
		ffmpeg -i "$file" -f mpegts -b 8000k -maxrate 9800k -r 25 -s hd1080 -aspect 16:9 -bufsize 1835k -ar 48000 -ab 224k -metadata service_provider="UESTC" -metadata service_name="210337" "${file}.ts"			
	else
		notify-send "mencoder and ffmpeg don't exsit" -u critical
		exit 0
	fi
	
	if [ -f "${file}.ts" ];then
		notify-send "<${file##*/}> convert complete"	
	else
		notify-send "<${file##*/}> convert failed" -u critical
	fi

	let i=i+1
done

