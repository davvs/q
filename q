#!/bin/bash
Q_HOME=$(dirname $(which q))
STARTED=$(date +%s)
$*
if [ $? -eq 0 ];
then
    RESULT=Success
else
    RESULT=Failed\($?\)
fi
COMPLETED=$(date +%s)

THRESHOLD=2

TIMETAKEN=$(( $COMPLETED - $STARTED ))

if [[ $TIMETAKEN -gt $THRESHOLD ]];
then
    aplay -q $Q_HOME/noise.wav &
    tell $RESULT: $*
fi
