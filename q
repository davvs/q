#!/bin/bash
Q_HOME=$(dirname $(which q))
STARTED=$(date +%s)
SOUND_EXECUTABLE=
SOUND_EXECUTABLE_FLAGS=
THRESHOLD_S=2

if [ $( which aplay 2> /dev/null ) ];
then
    SOUND_EXECUTABLE=aplay
    SOUND_EXECUTABLE_FLAGS="-q"
elif [ $( which afplay 2> /dev/null ) ];
then
    SOUND_EXECUTABLE=afplay
    SOUND_EXECUTABLE_FLAGS=
fi

$*
if [ $? -eq 0 ];
then
    RESULT=Success
else
    RESULT=Failed\($?\)
fi
COMPLETED=$(date +%s)


TIMETAKEN=$(( $COMPLETED - $STARTED ))

if [ $TIMETAKEN -ge $THRESHOLD_S ];
then
    if [ "${SOUND_EXECUTABLE}x" != "x" ];
    then
        $SOUND_EXECUTABLE $SOUND_EXECUTABLE_FLAGS $Q_HOME/noise.wav &
    fi
    tell $RESULT: $*
fi
