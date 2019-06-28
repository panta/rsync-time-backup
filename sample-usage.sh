#!/bin/bash

NAME=sample-rsync-tmbackup

TESTDIR=$(pwd)/test

: ${REMOTE_SRC:=user@remote:/}
: ${BACKUP_DST:=${TESTDIR}/backups}
: ${BACKUP_LOGS:=${TESTDIR}/logs}
: ${SSH_KEY:="$HOME/.ssh/id_rsa"}
: ${STRATEGY:="1:1 30:7 365:30"}
: ${TZ:=Europe/Rome}

mkdir -p ${BACKUP_DST}
mkdir -p ${BACKUP_LOGS}
touch ${BACKUP_DST}/backup.marker

docker kill $NAME
docker rm  $NAME
docker create \
  --name=$NAME \
  -v "${SSH_KEY}":/id_ssh \
  -v "${BACKUP_LOGS}":/backup-logs \
  -v "${BACKUP_DST}":/backups \
  -e RSYNCTM_ID_RSA="/id_ssh" \
  -e RSYNCTM_SRC="${REMOTE_SRC}" \
  -e RSYNCTM_DST=/backups \
  -e RSYNCTM_STRATEGY="${STRATEGY}" \
  -e RSYNCTM_LOG_DIR=/backup-logs \
  -e TZ="${TZ}" \
  -e FORCE_BACKUP=1 \
  -e CRON="0 1 * * *" \
  -e CRON_ABORT="0 6 * * *" \
  panta/rsync-time-backup:latest
docker start $NAME

echo "Type:"
echo
echo "  docker stop $NAME"
echo
echo "to stop the container."
echo
