#!/bin/bash

sleep 3s

TESTWATCH='/home/user/project'
test='/home/user/project/buster_test.sh'

[ -f $test ] && $test &&

# bez -e modify bo zbyt czesto bylo wywolywane...
inotifywait -mr --timefmt '%d/%m/%y %H:%M:%S' --format '%T %w %f %e' \
-e close_write -e moved_to -e create -e delete \
--exclude ".svn|.git|config|doc|log|lib|public|tmp|vendor" \
$TESTWATCH | while read date time dir file event; do

    echo $event ' on ' $file ' at ' $time

    $test &


done
