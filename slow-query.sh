#!/bin/bash

COMMAND=`basename $0`
HOSTNAME=`hostname`
CURRENT_DATE=`date +%Y%m%d`
USAGE="Usage: $COMMAND -m MAIL -c CNF -l LOG"

while getopts m:c:l: OPTION
do
    case $OPTION in
        m)
            MAILTO=$OPTARG
            ;;
        c)
            CNF_FILE=$OPTARG
            ;;
        l)
            LOG_FILE=$OPTARG
            ;;
        *)
            echo $USAGE 1>&2
            exit 1
            ;;
    esac
done

# Option check
if [ ! $MAILTO ] || [ ! $CNF_FILE ] || [ ! $LOG_FILE ]; then
    echo $USAGE 1>&2
    exit 1
fi

# Config file
if [ ! -r $CNF_FILE ]; then
    echo "Cannot read file: $CNF_FILE" 1>&2
    exit 1
fi

# Log file
if [ ! -r $LOG_FILE ]; then
    echo "Cannot read file: $LOG_FILE" 1>&2
    exit 1
fi

# Command check
if type -p mysqldumpslow >/dev/null; then
    MYSQL_DUMP_SLOW=`type -p mysqldumpslow`
else
    echo 'Command not found: mysqldumpslow' 1>&2
    exit 1
fi

# Command check
if type -p mysqladmin >/dev/null; then
    MYSQL_ADMIN=`type -p mysqladmin`
else
    echo 'Command not found: mysqladmin' 1>&2
    exit 1
fi

if [ -s $LOG_FILE ]; then
    $MYSQL_DUMP_SLOW $LOG_FILE | mail -s 'Slow Query for '$HOSTNAME $MAILTO
    mv $LOG_FILE $LOG_FILE.$CURRENT_DATE
    $MYSQL_ADMIN --defaults-extra-file=$CNF_FILE flush-logs
fi

exit 0
