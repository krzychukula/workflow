#!/bin/bash

#start
gnome-terminal --geometry=100x30+1600+0 \
 --tab --command '/home/user/project/buster_server.sh' \
 --tab --command '/home/user/project/buster_test_watcher.sh'

echo 'Wait 1s for browser tab to be open'
sleep 1s && google-chrome localhost:1111

exit 0
#run tests
#bash tsync.sh &