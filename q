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


play_sound() {
    set -e
    $SOUND_EXECUTABLE $SOUND_EXECUTABLE_FLAGS $Q_HOME/noise.wav &
}

usage() { echo "Usage: $0 [--test] [-p <pid>] <command>" 1>&2; exit 1; }

while getopts "tp:" o; do
    case "${o}" in
        t)
            echo this is test
            play_sound
            tell This is a simple test, testing q
            shift
            exit 0
            ;;
        p)
            PID=${OPTARG}
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

is_process_alive() {
    ps -p $1 >/dev/null
    return $?
}

echo $PID
if [ -n "$PID" ];
then
    COMMAND_INFO=$(ps -ocmd -p $PID | tail -1)
    if ! is_process_alive $PID; 
    then
        echo No process with PID $PID
        exit
    fi
    echo Watching pid $PID: $COMMAND_INFO
    while is_process_alive $PID;
    do
        sleep 3s
    done
    RESULT=Finished
else
    COMMAND_INFO=$*
    $*
    if [ $? -eq 0 ];
    then
        RESULT=Success
    else
        RESULT=Failed\($?\)
    fi
fi

COMPLETED=$(date +%s)
TIMETAKEN=$(( $COMPLETED - $STARTED ))

if [ $TIMETAKEN -ge $THRESHOLD_S ];
then
    if [ "${SOUND_EXECUTABLE}x" != "x" ];
    then
        play_sound
    fi
    tell $RESULT: $COMMAND_INFO
fi
