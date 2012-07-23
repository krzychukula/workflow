#!/bin/bash

tempfile='/tmp/my_project_temp'


function ctrl_c() {
    [ -f $tempfile ] && rm -f $tempfile
    #echo "** Trapped CTRL-C in buster_test.sh"
    exit
}
trap ctrl_c INT
trap ctrl_c EXIT

testcode() {
    [ -f $tempfile ] && printf -- "\nAlready running!\n" && exit 0

    touch $tempfile
    #-r quiet
    testresult=`buster test -l info -o -R --reporter quiet --color none --config /home/user/project/spec/javascript/buster.js`

    #1 error, 0- true

    testresult=`awk 'match($0,"Chrome: Reset") == 0 {print $0}' <(echo "$testresult")`
    testresult=`awk 'match($0,"Chrome ") == 0 {print $0}' <(echo "$testresult")`
    testresult=`awk 'match($0,"All browsers") == 0 {print $0}' <(echo "$testresult")`
    testresult=`awk 'match($0,"Running tests:") == 0 {print $0}' <(echo "$testresult")`
    testresult=`awk 'match($0,"Creating browser session") == 0 {print $0}' <(echo "$testresult")`
    testresult=`awk 'match($0,"Connected to server") == 0 {print $0}' <(echo "$testresult")`
    testresult=`awk 'match($0,"Running all") == 0 {print $0}' <(echo "$testresult")`
    testresult=`awk 'match($0,"Successfully closed") == 0 {print $0}' <(echo "$testresult")`

    echo "$testresult"

    if [[
        "$testresult" == *"0 failures, 0 errors, 0 timeouts"* &&
         "$testresult" != *"Tests failed:"* &&
          "$testresult" != *"DEBUG"* &&
           "$testresult" != *"Failure"* &&
            "$testresult" != *"Error:"*  ]];
    then
        notify-send -t 200 "Test OK      "`date +%T` "$testresult"
    else
        notify-send -t 200 "Tests failed "`date +%T` "$testresult"
    fi

    printf -- '--------------------\n'

    rm $tempfile
}

testcode