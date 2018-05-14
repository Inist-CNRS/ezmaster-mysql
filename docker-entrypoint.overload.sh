#!/bin/bash

# inject config.json parameters to env
# only if not already defined in env
export DUMP_EACH_NBHOURS=${DUMP_EACH_NBHOURS:=$(jq -r -M .DUMP_EACH_NBHOURS /config.json | grep -v null)}
export DUMP_CLEANUP_MORE_THAN_NBDAYS=${DUMP_CLEANUP_MORE_THAN_NBDAYS:=$(jq -r -M .DUMP_CLEANUP_MORE_THAN_NBDAYS /config.json | grep -v null)}
export MYSQL_DATABASE=${MYSQL_DATABASE:=$(jq -r -M .DATABASES[0].NAME /config.json | grep -v null)}
export MYSQL_USER=${MYSQL_USER:=$(jq -r -M .DATABASES[0].USER /config.json | grep -v null)}
export MYSQL_PASSWORD=${MYSQL_PASSWORD:=$(jq -r -M .DATABASES[0].PASSWORD /config.json | grep -v null)}

if [ -d "/var/lib/mysql" ]; then
	apply.config.sh &
fi

# backup/dump stuff
dump.periodically.sh &

# basic http server for displaing a basic informative html page for ezmaster 
cd /www && python -m SimpleHTTPServer 8080 &

# start mysql daemon
exec /usr/local/bin/docker-entrypoint.sh $@
