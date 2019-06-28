rsync-time-backup
=================

Docker image wrapping the excellent [rsync_tmbackup.sh](https://github.com/laurent22/rsync-time-backup) script.

To paraphrase the original script README, this image offers Time Machine-style backup using rsync. It creates incremental backups of files and directories to the destination of your choice. The backups are structured in a way that makes it easy to recover any file at any point in time.

Being a docker image, it can run almost anywhere: on a Linux, macOS or Windows machine or on most NAS supporting virtualization.

## Configuration

A few environment variables allow you to customize the behavior of the backup:

* `RSYNCTM_SRC` source location for backup command
* `RSYNCTM_DST` destination location for backup command
* `RSYNCTM_STRATEGY` backup strategy (see rsync_tmbackup.sh docs, defaults to `1:1 30:7 365:30`)
* `RSYNCTM_LOG_DIR` directory for backup logs
* `RSYNCTM_ID_RSA` ssh key file path
* `RSYNCTM_PORT` remote port for rsync
* `CRON` crontab schedule `0 0 * * *` to perform sync every midnight
* `CRON_ABORT` crontab schedule `0 6 * * *` to abort sync at 6am
* `FORCE_BACKUP` set variable to perform a backup upon boot
* `CHECK_URL` [healthchecks.io](https://healthchecks.io) url or similar cron monitoring to perform a `GET` after a successful sync
* `TZ` set the [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to use for the cron and log

## Usage

```bash
$ DEST=/path/to/destination
$ mkdir -p $DEST
$ touch $DEST/backup.marker
$ docker run --rm -it \
    -v $HOME/.ssh/id_rsa:/id_rsa \
    -v $DEST:/backups \
    -e RSYNCTM_SRC="user@remote:/source/path" \
    -e RSYNCTM_DST="$DEST" \
    -e RSYNCTM_ID_RSA="/id_ssh" \
    -e RSYNCTM_STRATEGY="1:1 30:7 365:30" \
    -e TZ="Europe/Rome" \
    -e CRON="0 0 * * *" \
    -e CRON_ABORT="0 6 * * *" \
    -e FORCE_BACKUP=1 \
    panta/rsync-time-backup:latest
```

See also the example script at `sample-usage.sh`:

```bash
$ REMOTE_SRC="user@remote:/source/path" SSH_KEY="$HOME/.ssh/my_ssh_key" ./sample-usage.sh
```

## License

This software is released under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

## References

* https://github.com/laurent22/rsync-time-backup
* https://github.com/bcardiff/docker-rclone
* https://www.whatsdoom.com/posts/2017/11/07/restricting-rsync-access-with-ssh/
