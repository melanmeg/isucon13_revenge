#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2086
# shellcheck disable=SC2164
# shellcheck disable=SC2002

cd $(dirname $0)

mysql -u isucon -pisucon -e "DROP DATABASE IF EXISTS isupipe"
mysql -u isucon -pisucon -e "CREATE DATABASE IF NOT EXISTS isupipe"

cat ./webapp/sql/initdb.d/10_schema.sql | sudo mysql isupipe
bash ./webapp/sql/init.sh

cd ./webapp/go
make

sudo systemctl restart isupipe-go

sudo rm -f /var/log/nginx/access.log
sudo systemctl restart nginx
sudo rm -f /var/log/mysql/mysql-slow.sql
sudo systemctl restart mysql

sudo chmod 644 /etc/powerdns/pdns.conf
