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