#!/bin/sh

set -e

if [ ! -z "$TZ" ]
then
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ > /etc/timezone
fi

rm -f /tmp/backup.pid

if [ -z "$RSYNCTM_SRC" ] || [ -z "$RSYNCTM_DST" ]
then
  echo "INFO: No RSYNCTM_SRC and RSYNCTM_DST found."
  echo "INFO: Define RSYNCTM_SRC and RSYNCTM_DST to start backup process."
else
  # RSYNCTM_SRC and RSYNCTM_DST setup
  # run backup either once or in cron depending on CRON
  if [ -z "$CRON" ]
  then
    echo "INFO: No CRON setting found. Running backup once."
    echo "INFO: Add CRON=\"0 0 * * *\" to perform backup every midnight"
    /backup.sh
  else
    if [ -z "$FORCE_BACKUP" ]
    then
      echo "INFO: Add FORCE_BACKUP=1 to perform a backup upon boot"
    else
      /backup.sh
    fi

    # Setup cron schedule
    crontab -d
    echo "$CRON /backup.sh >>/tmp/backup.log 2>&1" > /tmp/crontab.tmp
    if [ -z "$CRON_ABORT" ]
    then
      echo "INFO: Add CRON_ABORT=\"0 6 * * *\" to cancel outstanding backup at 6am"
    else
      echo "$CRON_ABORT /backup-abort.sh >>/tmp/backup.log 2>&1" >> /tmp/crontab.tmp
    fi
    crontab /tmp/crontab.tmp
    rm /tmp/crontab.tmp

    # Start cron
    echo "INFO: Starting crond ..."
    touch /tmp/backup.log
    touch /tmp/crond.log
    crond -b -l 0 -L /tmp/crond.log
    echo "INFO: crond started"
    tail -F /tmp/crond.log /tmp/backup.log
  fi
fi

