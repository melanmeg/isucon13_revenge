# isucon13_revenge

### ref

- https://github.com/matsuu/aws-isucon/tree/main/isucon13

### Start

1. CloudFormation で isucon13_ami_deploy_1server.yml をデプロイする

2. Windows の hosts にターゲットの IP を追加　（+ VSCode の ssh config に追加）

```bash
x.x.x.x pipe.u.isucon.local
x.x.x.x test001.u.isucon.local
```

3. 初期化

- Github Actions
  - 変数とシークレットを設定して isu init を実行
- ローカルの ansible

```yaml
# ansible/hosts
[isu1]
x.x.x.x

[isu-bm]
y.y.y.y
```

```bash
$ ansible-playbook -i hosts ansible/playbooks/isu_init.yml --private-key="./isucon13.pem"

# 開発環境も構築する場合
$ ansible-playbook -i hosts ansible/playbooks/isu_dev.yml --private-key="./isucon13.pem"
```

4. ベンチマーク

```bash
$ ansible-playbook -i hosts ansible/playbooks/isu_bm.yml --private-key="./isucon13.pem" -e "target_ip=x.x.x.x"
```

### ログイン

- URL: https://pipe.u.isucon.local
- ID: test001
- PW: test

### deploy

```bash
$ ansible-playbook -i hosts ansible/playbooks/isu_deploy.yml --private-key="./isucon13.pem"
```
