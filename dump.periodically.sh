#!/bin/bash
# script looping indefinitly and doing each X hours
# a mysqldump into /ezdata/dump folder

while true
do
  # loop until the database is ready to accept connections
  echo -n "Waiting until mysqld is ready to run mysqldump."
  until nc -z 127.0.0.1 27017
  do
    echo -n "."
    sleep 1
  done  

  DUMP_FILE=/ezdata/dump/dump.$(date '+%Y-%m-%d_%Hh%M').archive
  echo "Creating a dump with mysqldump in $DUMP_FILE"
  mysqldump --all-databases > $DUMP_FILE
  
  echo "Cleaning old dump."
  tmpreaper --verbose ${DUMP_CLEANUP_MORE_THAN_NBDAYS}d /ezdata/dump/

  echo "Waiting $DUMP_EACH_NBHOURS hours before next dump."
  sleep ${DUMP_EACH_NBHOURS}h
done
