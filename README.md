# ezmaster-mysql

[![Docker Pulls](https://img.shields.io/docker/pulls/inistcnrs/ezmaster-mysql.svg)](https://registry.hub.docker.com/u/inistcnrs/ezmaster-mysql/)

MySQL for [ezmaster](https://github.com/Inist-CNRS/ezmaster)

## Parameters

* ``DUMP_EACH_NBHOURS``: number of hours to wait before a new dump is generated in the ezmaster dataPath (default is 24)
* ``DUMP_CLEANUP_MORE_THAN_NBDAYS``: number of days dumps should be kept (default is 30 days)

Listening port is the mysqld default one: 3306
