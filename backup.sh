#!/bin/sh

set -e

echo "INFO: Starting backup.sh pid $$ $(date)"

if [ `lsof | grep $0 | wc -l | tr -d ' '` -gt 1 ]
then
  echo "WARNING: A previous backup is still running. Skipping new backup command."
else

  echo $$ > /tmp/backup.pid

  # TODO: check that source directory is not empty (eg. using rclone)
  /rsync_tmbackup.sh \
    --id_rsa "${RSYNCTM_ID_RSA}" \
    --rsync-append-flags "${RSYNCTM_FLAGS}" \
    --log-dir "${RSYNCTM_LOG_DIR}" \
    --strategy "${RSYNCTM_STRATEGY}" \
    "${RSYNCTM_SRC}" "${RSYNCTM_DST}"

  if [ -z "$CHECK_URL" ]
  then
    echo "INFO: Define CHECK_URL with https://healthchecks.io to monitor backup job"
  else
    wget $CHECK_URL -O /dev/null
  fi

  rm -f /tmp/backup.pid

fi
