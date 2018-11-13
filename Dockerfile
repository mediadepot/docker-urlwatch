FROM theiaide/theia:latest as builder
###############################################################################
# Build Image
# using modified version of https://github.com/theia-ide/theia-apps/blob/master/theia-docker/Dockerfile
###############################################################################


###############################################################################
# Runtime Image
###############################################################################
FROM mediadepot/base:python3

# Install Theia
RUN apk add --no-cache bash nodejs

RUN mkdir -p /srv/theia/app
COPY --from=builder /home/theia /srv/theia/app

# based on https://github.com/alexrashed/docker-urlwatch2/blob/master/Dockerfile
RUN apk add --no-cache libffi-dev sshpass openssh

RUN pip3 install pyyaml minidb requests keyring chump pushbullet.py urlwatch

# add local files
COPY rootfs/ /


# ports and volumes
VOLUME ["/srv/theia/config","/srv/urlwatch/config", "/srv/urlwatch/data"]
EXPOSE 8081

CMD ["/init"]


## Put all logfiles into a volume.
## Workaround for bug https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=810669
#VOLUME /var/log/
#
#RUN mkdir /config && mkdir /volume
#
#WORKDIR /config
#
#ENV LC_ALL="C.UTF-8"
#ENV LANG="C.UTF-8"
#
#ENV SCHEDULE="*/15 * * * *"
#
#CMD echo "$SCHEDULE /bin/date >> /var/log/urlwatch.log 2>&1 && LANG=C.UTF-8 /usr/local/bin/urlwatch --urls /config/urls.txt --config /config/urlwatch.yaml --hooks /config/hooks.py --cache /volume/cache.db >> /var/log/urlwatch.log 2>&1" | crontab - && touch /var/log/urlwatch.log && cron && tail -f /var/log/urlwatch.log