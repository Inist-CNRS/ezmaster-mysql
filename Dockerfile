FROM mysql:8.0

# need jq to parse JSON
# netcat to wait for when mysql is ready to listen
# tmpreaper to cleanup old dump
# python for a basic http server used for ezmaster
# vim for debug stuff
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y install netcat jq tmpreaper vim python

COPY config.json /
COPY docker-entrypoint.overload.sh /usr/local/bin/

# mysql data folder dedicated to ezmaster
# because it's not yet (8 nov 2017) possible to UNVOLUME /data/db and /data/configdb
RUN mkdir -p /ezdata/db && chown -R mysql:mysql /ezdata/db
COPY mysqld.cnf /etc/mysql/config/conf.d/

# backup stuff
RUN mkdir -p /ezdata/dump/
COPY dump.periodically.sh /usr/local/bin/
COPY apply.config.sh /usr/local/bin/

# basic http server stuff
RUN mkdir /www
COPY index.* /www/

# ezmasterization of refgpec
# see https://github.com/Inist-CNRS/ezmaster
# notice: httpPort is useless here but as ezmaster require it (v3.8.1) we just add a wrong port number
RUN echo '{ \
  "httpPort": 8080, \
  "configPath": "/config.json", \
  "configType": "json", \
  "dataPath": "/ezdata" \
}' > /etc/ezmaster.json


ENV MYSQL_ROOT_PASSWORD_FILE /run/secrets/mysql-root

ENTRYPOINT [ "docker-entrypoint.overload.sh" ]
CMD [ "mysqld", "--default-authentication-plugin=mysql_native_password" ]
