# ISUCON Commands

### shell

```
# archive
tar zcvfp /tmp/webapp.tar.gz /home/isucon/private_isu/webapp

# mysqldump
mysqldump -u isuconp isuconp | gzip > /tmp/isuconp.dump.sql.gz

# scp
scp isu1:/tmp/webapp.tar.gz ./
scp isu1:/tmp/isuconp.dump.sql.gz ./
scp isu1:/etc/nginx/nginx.conf ./

# remove
rm -f /tmp/webapp.tar.gz
rm -f /tmp/isuconp.dump.sql.gz

# mysql
mysql -u isucon -pisucon
```

---

### pprof

```
# profile
sudo curl -o cpu.pprof http://localhost:6060/debug/pprof/profile?seconds=60
sudo go tool pprof -http localhost:1080 cpu.pprof
ssh -N -L 0.0.0.0:1080:localhost:1080 isu1
http://localhost:1080/
#http://192.168.11.21:1080/
```

---

### alp

```
sudo cat /var/log/nginx/access.log \
| alp ltsv -m '/image/[0-9]+,/posts/[0-9]+,/@\w' \
--sort avg -r -o count,1xx,2xx,3xx,4xx,5xx,min,max,avg,sum,p99,method,uri
```

---

### pt-query-digest

```
#sudo sed -i '/^INSERT INTO `posts`/d' /var/log/mysql/mysql-slow.sql
sudo pt-query-digest /var/log/mysql/mysql-slow.sql
```

---

### unarchive

```
rm -rf ../test-private_isu/webapp/ && \
tar zxvfp ./files/fetch/webapp.tar.gz -C ../test-private_isu/ && \
mv ../test-private_isu/home/isucon/private_isu/webapp ../test-private_isu/ && \
rm -rf ../test-private_isu/home/
```

---

### ssh port foward

```
ssh -N -L 0.0.0.0:19999:localhost:19999 isu1  # netdata
ssh -N -L 0.0.0.0:1080:localhost:1080 isu1  # pprof
ssh -N -L 0.0.0.0:3306:localhost:3306 isu1  # mysql
ssh -N -L 0.0.0.0:8080:localhost:8080 isu1  # grafana
ssh -N -L 0.0.0.0:9100:localhost:9100 isu1  # node_exporter
ssh -N -L 0.0.0.0:3100:localhost:3100 isu1  # fluent-bit

# Case of background
ssh -fN -L 0.0.0.0:19999:localhost:19999 isu1  # netdata

# access
http://localhost:1080/
#http://192.168.11.21:1080/

# wipe ps
kill $(ps aux | grep 'ssh -fN -L 0.0.0.0:19999:localhost:19999 isu1' | grep -v grep | awk '{print $2}')
kill $(ps aux | grep 'ssh -fN -L 0.0.0.0:1080:localhost:1080 isu1' | grep -v grep | awk '{print $2}')
ps aux | grep ssh
```
