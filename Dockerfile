FROM alpine:latest
MAINTAINER Marco Pantaleoni <marco.pantaleoni@gmail.com>

# Based on:
#   - https://github.com/bcardiff/docker-rclone

# build-time parameters
ARG RCLONE_VERSION=current
ARG ARCH=amd64

# env variables

# default strategy "1:1 30:7 365:30":
#    After 1 day, keep one backup every 1 day (1:1).
#    After 30 days, keep one backup every 7 days (30:7).
#    After 365 days, keep one backup every 30 days (365:30).

ENV RSYNCTM_PORT=
ENV RSYNCTM_ID_RSA=
ENV RSYNCTM_FLAGS=
ENV RSYNCTM_LOG_DIR=
ENV RSYNCTM_STRATEGY="1:1 30:7 365:30"
ENV RSYNCTM_SRC=
ENV RSYNCTM_DST=
# ENV SYNC_SRC=
# ENV SYNC_DEST=
# ENV SYNC_OPTS=-v
# ENV RCLONE_OPTS="--config /config/rclone.conf"
ENV CRON=
ENV CRON_ABORT=
ENV FORCE_BACKUP=
ENV CHECK_URL=
ENV TZ=

# Install base packages
RUN apk -U add ca-certificates fuse wget dcron tzdata rsync openssh-client bash coreutils findutils \
  && rm -rf /var/cache/apk/*

# Install rclone
RUN URL=http://downloads.rclone.org/${RCLONE_VERSION}/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip ; \
  URL=${URL/\/current/} ; \
  cd /tmp \
  && wget -q $URL \
  && unzip /tmp/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip \
  && mv /tmp/rclone-*-linux-${ARCH}/rclone /usr/bin \
&& rm -r /tmp/rclone*

COPY entrypoint.sh /
COPY backup.sh /
COPY backup-abort.sh /
COPY rsync_tmbackup.sh /

# VOLUME ["/config"]

ENTRYPOINT ["/entrypoint.sh"]

CMD [""]
