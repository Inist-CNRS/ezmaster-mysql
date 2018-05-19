#!/bin/bash

IN=`jq -r '.DATABASES[] | "\(.NAME) \(.USER) \(.PASSWORD) ;"' /config.json`
ROOT_PASSWORD=`cat /run/secrets/mysql-root`
mysql=( mysql --protocol=socket -uroot -hlocalhost --socket=/var/run/mysqld/mysqld.sock --password="${ROOT_PASSWORD}" )

forEachDatabase() {
echo -n "Changing password for ${2}."
"${mysql[@]}" <<-EOSQL
	SET @@SESSION.SQL_LOG_BIN=0 ;
	CREATE DATABASE IF NOT EXISTS \`${1}\` ;
	CREATE USER IF NOT EXISTS '${2}'@'%' IDENTIFIED BY '${3}' ;
	GRANT ALL ON \`${1}\`.* TO '${2}'@'%' ;
	ALTER USER ${2} IDENTIFIED BY '${3}' ;
	FLUSH PRIVILEGES ;
EOSQL
}

echo -n "Waiting until mysqld is ready before applying passwords stuff."
until nc -z 127.0.0.1 3306
do
	echo -n "."
	sleep 1
done

echo -n "Updating mysqld with the config file"
while IFS=';' read -ra ITEM; do
      for i in "${ITEM[@]}"; do
          forEachDatabase $i
      done
done <<< "$IN"
