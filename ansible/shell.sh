#!/bin/bash -eux

# sql init
sudo mysql -u isucon -pisucon -e "DROP DATABASE IF EXISTS isupipe"
sudo mysql -u isucon -pisucon -e "CREATE DATABASE IF NOT EXISTS isupipe"
sudo cat ~/webapp/sql/initdb.d/10_schema.sql | sudo mysql isupipe
sudo ~/webapp/sql/init.sh

# アプリケーションのビルド
APP_NAME=isupipe
cd /home/isucon/webapp/go/
go build -o ${APP_NAME}

# ミドルウェア・Appの再起動
sudo systemctl restart isupipe-go
sudo rm -f /var/log/nginx/access.log
sudo systemctl restart nginx
sudo rm -f /var/log/mysql/mysql-slow.sql
sudo systemctl restart mysql

# sudo pdnsutil delete-zone u.isucon.local
# sudo rm -f /opt/aws-env-isucon-subdomain-address.sh.lock
# sudo reboot
