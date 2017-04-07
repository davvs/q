#!/bin/bash
Q_HOME=$(dirname $(which q))
STARTED=$(date +%s)
SOUND_EXECUTABLE=
SOUND_EXECUTABLE_FLAGS=
THRESHOLD_S=2
ALWAYS_SHOW=0
SHOW_OUTPUT=0
QUIET=0

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

usage() { echo "Usage: $0 [--test] [-p <pid>] [-s] [-o] <command>" 1>&2; exit 1; }

while getopts "qtsop:" opt; do
    case "${opt}" in
        t)
            echo this is test
            play_sound
            tell This is a simple test, testing q
            exit 0
            ;;
        p)
            PID=${OPTARG}
            ;;
        s)
            ALWAYS_SHOW=1
            ;;
        o)
            SHOW_OUTPUT=1
            ;;
        q)
            QUIET=1
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))


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
    if [ $SHOW_OUTPUT -eq 0 ];
    then
        COMMAND_INFO=$*
        $*
    else
        exec 5>&1
        COMMAND_INFO=$($* | tee /dev/fd/5)
    fi

    if [ $? -eq 0 ];
    then
        RESULT=Success
    else
        RESULT=Failed\($?\)
    fi
fi

COMPLETED=$(date +%s)
TIMETAKEN=$(( $COMPLETED - $STARTED ))

if [ $ALWAYS_SHOW -ne 0 -o $TIMETAKEN -ge $THRESHOLD_S ];
then
    if [ "${SOUND_EXECUTABLE}x" != "x" -a $QUIET -eq 0 ];
    then
        play_sound
    fi
    tell $RESULT: $COMMAND_INFO
fi
