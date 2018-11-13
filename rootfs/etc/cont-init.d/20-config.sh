#!/usr/bin/with-contenv bash

# make folders (Original)
mkdir -p \
	/srv/urlwatch/app \
	/srv/urlwatch/data \
	/srv/urlwatch/config \
	/srv/theia/app \
	/srv/theia/config

# urlwatch config files

# urlwatch configuration
if [ ! -f /srv/urlwatch/config/urls.yaml ]; then
	touch /srv/urlwatch/config/urls.yaml
fi
if [ ! -f /srv/urlwatch/config/urlwatch.yaml ]; then
	touch /srv/urlwatch/config/urlwatch.yaml
fi


if [ ! -f /etc/periodic/15min/urlwatch ]; then
cat > /etc/periodic/15min/urlwatch <<DELIM
#!/bin/sh
LANG=C.UTF-8 /usr/local/bin/urlwatch --urls /srv/urlwatch/config/urls.yaml --config /srv/urlwatch/config/urlwatch.yaml --cache /srv/urlwatch/data/cache.db
DELIM

fi

# permissions
chown mediadepot:users -R /srv/urlwatch
chown mediadepot:users -R /srv/theia
