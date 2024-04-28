# isucon13_revenge

### ref

- https://github.com/matsuu/aws-isucon/tree/main/isucon13

```bash
find ${GITDIR} -type f -exec sed -i -e "s/u\.isucon\.dev/u.isucon.local/g" {} +
```

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

# ubuntuユーザーでisu-benchにログインして、以下を実行する
$ sudo su -
$ cp /home/ubuntu/.ssh/authorized_keys /home/isucon/.ssh/ && \
  chown isucon:isucon /home/isucon/.ssh/authorized_keys && \
  hostnamectl set-hostname isu-bench && \
  echo "10.1.1.11 isu-bm" >> /etc/hosts && \
  echo "x.x.x.x(isu1,2,3) pipe.u.isucon.local" >> /etc/hosts && \
  echo "x.x.x.x(isu1,2,3) test001.u.isucon.local" >> /etc/hosts
```

- 3 Github Actions で 変数とシークレットを設定して isu1 を実行

- 4 Windows の hosts に以下のように追加

```bash
x.x.x.x(isu1,2,3) pipe.u.isucon.local
x.x.x.x(isu1,2,3) test001.u.isucon.local
```

- 5

```bash
# devドメインはHSTSが強制有効でブラウザでの動作確認が難しいためドメインを書き換える
$ sudo su -
$ cd /etc/nginx/tls/ && \
openssl req -subj '/CN=*.t.isucon.local' -nodes -newkey rsa:2048 -keyout _.u.isucon.local.key -out _.u.isucon.local.csr && \
echo "subjectAltName=DNS.1:*.u.isucon.local, DNS.2:*.u.isucon.dev" > extfile.txt && \
openssl x509 -in _.u.isucon.local.csr -req -signkey _.u.isucon.local.key -sha256 -days 3650 -out _.u.isucon.local.crt -extfile extfile.txt && \
cp -p _.u.isucon.local.crt _.u.isucon.local.issuer.crt

systemctl restart nginx
```

- 6.x

```bash
sudo chmod 644 /etc/powerdns/pdns.conf
```

- 6

### ※再起動後はドメインなど反映に時間がかかりそう

```bash
$ sudo su -
$ pdnsutil delete-zone u.isucon.local && \
  pdnsutil delete-zone u.isucon.dev && \
  rm -f /opt/aws-env-isucon-subdomain-address.sh.lock
$ reboot
```

- 7 Github Actions で 再度 isu1 を実行

- 8 https://pipe.u.isucon.local

  - ID: test001
  - PW: test

- 9 isu-bench でベンチマーク実行

```bash
$ cd ~ && \
  git clone https://github.com/megutamago/isucon13_revenge.git && \
  mv isucon13_revenge/bench ~ && \
  rm -rf isucon13_revenge && \
  sed -i -e '/InsecureSkipVerify/s/false/true/' ./bench/cmd/bench/benchmarker.go ./bench/cmd/bench/bench.go
$ cd ./bench && make

$ ./bin/bench_linux_amd64 run --target https://pipe.u.isucon.local \
  --nameserver x.x.x.x(isu1,2,3) --enable-ssl
```
