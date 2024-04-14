#!/bin/bash
set -eu

# ls nginx
cat <<EOF

#####################################
#             systemctl             #
#####################################

EOF
ls -l /etc/nginx

# ls mysql
cat <<EOF

#####################################
#             systemctl             #
#####################################

EOF
ls -l /etc/mysql/*

# systemctl
cat <<EOF

#####################################
#             systemctl             #
#####################################

EOF

cat <<EOF >/tmp/pattern.txt
apparmor.service
apport.service
blk-availability.service
cloud-config.service
cloud-final.service
cloud-init-local.service
cloud-init.service
console-setup.service
cron.service
dbus.service
finalrd.service
getty@tty1.service
irqbalance.service
keyboard-setup.service
kmod-static-nodes.service
lvm2-monitor.service
multipathd.service
networkd-dispatcher.service
packagekit.service
plymouth-quit-wait.service
plymouth-quit.service
plymouth-read-write.service
polkit.service
rsyslog.service
serial-getty@ttyS0.service
setvtrgb.service
snapd.apparmor.service
snapd.seeded.service
snapd.service
ssh.service
systemd-fsck-root.service
systemd-fsck@dev-disk-by\x2dlabel-UEFI.service
systemd-journal-flush.service
systemd-journald.service
systemd-logind.service
systemd-machine-id-commit.service
systemd-modules-load.service
systemd-networkd-wait-online.service
systemd-networkd.service
systemd-random-seed.service
systemd-remount-fs.service
systemd-resolved.service
systemd-sysctl.service
systemd-sysusers.service
systemd-timesyncd.service
systemd-tmpfiles-setup-dev.service
systemd-tmpfiles-setup.service
systemd-udev-trigger.service
systemd-udevd.service
systemd-update-utmp.service
systemd-user-sessions.service
ufw.service
unattended-upgrades.service
user-runtime-dir@1000.service
user@1000.service
EOF

systemctl list-units --all --type=service | grep -v inactive >/tmp/systemd-info.txt
grep -vf /tmp/pattern.txt /tmp/systemd-info.txt >/tmp/result.txt
cat /tmp/result.txt
rm -f /tmp/pattern.txt /tmp/systemd-info.txt /tmp/result.txt

# DB info
cat <<EOF

#####################################
#              DB info              #
#####################################

EOF
echo '######## SHOW DATABASES ########'
mysql -u isuconp -pisuconp isuconp -e "SHOW DATABASES;"
echo '######## SHOW TABLES ########'
mysql -u isuconp -pisuconp isuconp -e "SHOW TABLES;"

#mysql -u isuconp -pisuconp isuconp -e "SHOW VARIABLES \G"

echo '######## SHOW CREATE TABLE comments ########'
mysql -u isuconp -pisuconp isuconp -e "SHOW CREATE TABLE comments \G"
echo '######## SHOW CREATE TABLE posts ########'
mysql -u isuconp -pisuconp isuconp -e "SHOW CREATE TABLE posts \G"
echo '######## SHOW CREATE TABLE users ########'
mysql -u isuconp -pisuconp isuconp -e "SHOW CREATE TABLE users \G"

echo '######## show index from comments ########'
mysql -u isuconp -pisuconp isuconp -e "show index from comments\G"
echo '######## show index from posts ########'
mysql -u isuconp -pisuconp isuconp -e "show index from posts\G"

# MySQLTuner-perl
cat <<EOF

#####################################
#          MySQLTuner-perl          #
#####################################

EOF

wget http://mysqltuner.pl/ -O /tmp/mysqltuner.pl
perl /tmp/mysqltuner.pl
rm -f /tmp/mysqltuner.pl
