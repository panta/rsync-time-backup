#!/bin/sh

set -e

if [ ! -f /tmp/backup.pid ]
then
  echo "INFO: No outstanding backup $(date)"
else
  echo "INFO: Stopping backup pid $(cat /tmp/backup.pid) $(date)"

  pkill -P $(cat /tmp/backup.pid)
  kill -15 $(cat /tmp/backup.pid)
  rm -f /tmp/backup.pid
fi
