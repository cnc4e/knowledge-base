# 複数のリソースを効率的に作成する

Terraformで複数のリソースを作成する場合、リソースごとにresourceブロックを記述する必要があり、コードが冗長になりがちです。  
これを解消するため、Terraformではループ処理を活用して効率的にリソースを作成できます。このドキュメントでは、Terraformのループ処理を使った効率的なリソース管理方法について説明します。

## ループ処理の種類と違い

Terraformのループ処理には主に`for_each`と`for`の2種類があります。  
それぞれの特徴と用途を以下にまとめます。

### for_each

- 用途: リソースやモジュールをループさせて複数作成する場合に使用。
- 特徴:
  - 各リソースに一意のキーを割り当てることができる
  - リソースの作成や管理が容易になる

以下は、`for_each`を用いて複数のAWS S3バケットを一括作成する例です。

```hcl
resource "aws_s3_bucket" "example" {
  for_each = {
    bucket1 = "example-bucket-1"
    bucket2 = "example-bucket-2"
  }

  bucket = each.value
  tags = {
    Name = each.key
  }
}
```

### for

- 用途: 変数やoutputを加工して動的にリストやマップ作りたい場合に使用。
- 特徴:
  - 動的にリストやマップを生成できる
  - データの加工や変換が容易になる

以下は、`for`を用いてセキュリティグループのルールを動的に生成する例です。

```hcl
variable "ports" {
  default = [80, 443]
}

locals {
  ingress_rules = [for port in var.ports : {
    from_port = port
    to_port   = port
    protocol  = "tcp"
    cidr      = "0.0.0.0/0"
  }]
}

resource "aws_security_group" "example" {
  name = "example-sg"

  ingress {
    count       = length(local.ingress_rules)
    from_port   = local.ingress_rules[count.index].from_port
    to_port     = local.ingress_rules[count.index].to_port
    protocol    = local.ingress_rules[count.index].protocol
    cidr_blocks = [local.ingress_rules[count.index].cidr]
  }
}
```

---

- [前のページに戻る](README.md)
- [目次](README.md#目次)
- [次のページに進む](step02.md)
