#!/bin/bash

# get the current path
CURPATH=`pwd`
WATCHPATH='/home/user/project'
TOMCATTEMP='/home/user/tomcat/temp'
STARTNEWDHDIR=`ls -t $TOMCATTEMP | grep my-project-directory | head -1`

trap ctrl_c INT
function ctrl_c() {
    #kill ./server.sh
	kill %+
	#kill test driver
	ps xu | grep JsTestDriver | grep -v grep | awk '{print $2 }' | xargs kill -9
    echo "** Trapped CTRL-C"
    exit
}

echo "Sync from $WATCHPATH/ to $TOMCATTEMP/$STARTNEWDHDIR"

#initial sync
rsync --verbose --recursive --exclude=.svn $WATCHPATH/ $TOMCATTEMP/$STARTNEWDHDIR

# bez -e modify bo zbyt czesto bylo wywolywane...
inotifywait -mr --timefmt '%d/%m/%y %H:%M:%S' --format '%T %w %f %e' \
-e close_write -e moved_to -e create -e delete --exclude .svn $WATCHPATH | while read date time dir file event; do

	FILECHANGE=${dir}${file}
	#echo $FILECHANGE
	#echo "$dir    $file"

	if [ "$FILECHANGE" != *"svn"* ];
	then
		#echo "$FILECHANGE"
		#echo "$WATCHPATH"

		# convert absolute path to relative
		FILECHANGEREL=`echo "$FILECHANGE" | sed 's_'$WATCHPATH'/__'`
		#echo "$FILECHANGEREL"

		NEWDHDIR=`ls -t $TOMCATTEMP | grep dh-ui | head -1`

		rsync --exclude=.svn --verbose --recursive $FILECHANGE $TOMCATTEMP/$NEWDHDIR/$FILECHANGEREL

		echo "At ${time} on ${date}, event $event, on file $FILECHANGE was backed up via rsync to $TOMCATTEMP/$NEWDHDIR/$FILECHANGEREL"

		#Test with jstestdriver
		#bash test.sh &
	fi
done