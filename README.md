# isucon13_revenge

### Start

```bash
# CloudFormationでisucon13_ami_deploy_1server.ymlをデプロイする
```

```bash
# isu-1で以下を実行する
$ sudo su - && \
  cp /home/ubuntu/.ssh/authorized_keys /home/isucon/.ssh/ && \
  chown isucon:isucon /home/isucon/.ssh/authorized_keys && \
  hostnamectl set-hostname isu-1 && \
  echo "10.1.1.11 isu-1" >> /etc/hosts
```
