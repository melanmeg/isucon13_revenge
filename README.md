# isucon13_revenge

### ref

- https://github.com/matsuu/aws-isucon/tree/main/isucon13

````bash
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
  echo "10.1.1.11 isu-bench" >> /etc/hosts && \
  echo "54.248.195.183 pipe.u.isucon.local" >> /etc/hosts && \
  echo "54.248.195.183 test001.u.isucon.local" >> /etc/hosts
````

- 3 Github Actions で 変数とシークレットを設定して isu1 を実行

- 4 Windows の hosts に以下のように追加

```bash
x.x.x.x pipe.u.isucon.local
x.x.x.x test001.u.isucon.local
```

- 5

```bash
$ sudo pdnsutil delete-zone u.isucon.local
$ sudo pdnsutil delete-zone u.isucon.dev
$ sudo rm -f /opt/aws-env-isucon-subdomain-address.sh.lock
$ sudo reboot
```

- 6

```bash
cd /etc/nginx/tls/

# devドメインはHSTSが強制有効でブラウザでの動作確認が難しいためドメインを書き換える
openssl req -subj '/CN=*.t.isucon.local' -nodes -newkey rsa:2048 -keyout _.u.isucon.local.key -out _.u.isucon.local.csr
echo "subjectAltName=DNS.1:*.u.isucon.local, DNS.2:*.u.isucon.dev" > extfile.txt
openssl x509 -in _.u.isucon.local.csr -req -signkey _.u.isucon.local.key -sha256 -days 3650 -out _.u.isucon.local.crt -extfile extfile.txt
cp -p _.u.isucon.local.crt _.u.isucon.local.issuer.crt

systemctl restart nginx
```

- 7 https://pipe.u.isucon.local

test001 test

- 8 isu-bench でベンチマーク実行

```bash
$ cd ~ && \
  git clone https://github.com/megutamago/isucon13_revenge.git && \
  mv isucon13_revenge/bench ~ && \
  rm -rf isucon13_revenge && \
  sed -i -e '/InsecureSkipVerify/s/false/true/' ./bench/cmd/bench/benchmarker.go ./bench/cmd/bench/bench.go
$ cd ./bench && make

$ ./bin/bench_linux_amd64 run --target https://pipe.u.isucon.local \
  --nameserver 54.248.195.183 --enable-ssl
```
