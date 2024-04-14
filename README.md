# isucon13_revenge

### ref

- https://github.com/matsuu/aws-isucon/tree/main/isucon13

### Start

- 1 CloudFormation で isucon13_ami_deploy_1server.yml をデプロイする

- 2

```bash
# ubuntuユーザーでisu-1にログインして、以下を実行する
$ sudo su -
$ cp /home/ubuntu/.ssh/authorized_keys /home/isucon/.ssh/ && \
  chown isucon:isucon /home/isucon/.ssh/authorized_keys && \
  hostnamectl set-hostname isu-1 && \
  echo "10.1.1.11 isu-1" >> /etc/hosts
```

- 3 Github Actions で 変数とシークレットを設定して isu1 を実行

- 4 Windows の hosts に以下のように追加

```bash
x.x.x.x pipe.u.isucon.local
x.x.x.x test001.u.isucon.local
```

- 5

```bash
$ sudo pdnsutil delete-zone u.isucon.local
$ sudo rm -f /opt/aws-env-isucon-subdomain-address.sh.lock
$ sudo reboot
```

- 6

```bash
root@isu-1:~# ls -l /etc/nginx/tls/
total 28
-rw-r--r-- 1 root root 5591 Nov 27 12:06 _.t.isucon.dev.crt
-rw-r--r-- 1 root root 1675 Nov 27 12:06 _.t.isucon.dev.key
-rw-r--r-- 1 root root 5256 Nov 27 12:06 _.u.isucon.dev.crt
-rw-r--r-- 1 root root 3751 Nov 27 12:06 _.u.isucon.dev.issuer.crt
-rw-r--r-- 1 root root  227 Nov 27 12:06 _.u.isucon.dev.key

# 新しい自己署名証明書の作成
cd /etc/nginx/tls/
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout _.u.isucon.local.key -out _.u.isucon.local.crt -subj "/C=US/O=Let's Encrypt/CN=*.u.isucon.local"
systemctl restart nginx
```

- 7

```bash
cd /etc/nginx/tls/

# devドメインはHSTSが強制有効でブラウザでの動作確認が難しいためドメインを書き換える
openssl req -subj '/CN=*.t.isucon.local' -nodes -newkey rsa:2048 -keyout _.u.isucon.local.key -out _.u.isucon.local.csr
echo "subjectAltName=DNS.1:*.u.isucon.local, DNS.2:*.u.isucon.dev" > extfile.txt
openssl x509 -in _.u.isucon.local.csr -req -signkey _.u.isucon.local.key -sha256 -days 3650 -out _.u.isucon.local.crt -extfile extfile.txt
cp -p _.u.isucon.local.crt _.u.isucon.local.issuer.crt

# 自己署名証明書を利用するため
sed -i -e '/InsecureSkipVerify/s/false/true/' ${GITDIR}/bench/cmd/bench/benchmarker.go ${GITDIR}/bench/cmd/bench/bench.go
```

- 8 isu-bench でベンチマーク実行

```bash
./bench_linux_amd64 run --target https://pipe.u.isucon.dev \
  --nameserver x.x.x.x --enable-ssl
```
