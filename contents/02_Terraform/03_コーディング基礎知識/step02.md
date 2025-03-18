# 環境ごとのコードを共通化する

Terraformで複数の環境（例: 本番、開発、ステージング）を管理する際、環境ごとに個別のコードを用意すると、メンテナンスが煩雑になりやすくエラーの原因にもなります。基本的な構成が同じである場合は、コードを共通化することで効率的で管理しやすいインフラ構成が可能です。本記事では、Terraformを用いて環境ごとのコードを共通化する方法について解説します。

## コード共通化の課題

環境ごとに別々のコードを用意すると、同じ構成の変更を複数箇所で管理する必要があり保守性が低下します。環境ごとの微妙な差異（例: 本番環境では高性能なリソースを使用、開発環境では簡易構成を使用）をどのように実装するかが課題です。

これらの課題を解決するために、Terraformでは以下のようなアプローチが取られます。

### 1. 変数化による値の制御

本番環境ではインスタンスタイプを大きなものにするが、開発環境では小さなインスタンスタイプにするといった構成にしたい場合があります。
このような場合は、パラメータを変数化してモジュール実行時に異なる値を渡すようにする方法があります。
以下のように記載することで、本番環境と開発環境で設定の異なるインスタンスが作成できるようになります。

```hcl
variable "environment" {
  description = "Environment type (e.g., dev, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type based on environment"
  type        = string
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = var.instance_type
  tags = {
    Name = "example-${var.environment}"
  }
}
```

モジュールの使用例は以下のようになります。

```hcl
# 開発環境（小さなインスタンスタイプ）の場合
module "ec2" {
  source        = "./ec2"
  environment   = "dev"
  instance_type = "t2.micro"
}

# 本番環境（大きなインスタンスタイプ）の場合
module "ec2" {
  source        = "./ec2"
  environment   = "prod"
  instance_type = "m5.large"
}
```

### 2. 条件分岐と`count`でリソース作成の有無を制御

本番環境ではログをS3バケットに置くが、開発環境ではS3バケットを作成しないといった構成にしたいといった、環境ごとにリソースの作成有無を制御したい場合があります。  
このような場合は、`count`を条件付きで指定する方法があります。
以下のように記載することで、`var.create_resource`が`true`の場合は1個作成、`false`の場合は0個作成（＝作らない）となり、リソース作成の有無を制御できます。

```hcl
variable "create_resource" {
  description = "Whether to create the resource (true/false)"
  type        = bool
}

resource "aws_s3_bucket" "example" {
  count = var.create_resource ? 1 : 0

  bucket = "example-bucket"
  acl    = "private"
}
```

モジュールの使用例は以下のようになります。

```hcl
# S3バケットを作成しない場合
module "s3" {
  source          = "./s3"
  create_resource = false
}

# S3バケットを作成する場合
module "s3" {
  source          = "./s3"
  create_resource = true
}
```

### 3. `dynamic`ブロックで設定内容を柔軟に制御

resourceにはシンプルにパラメータを変更するだけで制御できる設定の他に、ブロック単位で設定を定義するパターンのものがあります。  
例として、本番環境ではEC2インスタンスにルートボリュームに加えてEBSを追加するが開発環境ではルートボリュームのみにしたいといった場合を考えます。  
EBSを追加する場合は、aws_instanceの中でebs_block_deviceを定義する必要がありますが、これは単純な変数化だけでは実現できません。
このような場合、dynamicを使用することで設定の有無を切り替えることができるようになります。

```hcl
# 追加ボリュームを設定するかどうかを制御する変数
variable "enable_ebs" {
  type    = bool
}

# 追加ボリュームの設定
variable "block_devices" {
  type = list(object({
    device_name = string
    volume_size = number
  }))
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  dynamic "ebs_block_device" {
    for_each = var.enable_ebs ? var.block_devices : []
    content {
      device_name = ebs_block_device.value.device_name
      volume_size = ebs_block_device.value.volume_size
    }
  }
}
```

モジュールの使用例は以下のようになります。

```hcl
# 追加ボリュームを設定しない
module "ec2" {
  source     = "./ec2"
  enable_ebs = false
}

# 追加ボリュームを設定する。
module "ec2" {
  source     = "./ec2"
  enable_ebs = true
  block_devices = [
    { device_name = "/dev/sdb", volume_size = 10 }
  ]
}
```

なお、上記の例では`enable_ebs`という変数で制御していますが、`block_devices`が空かどうかで制御させるといったコードにすることも考えられます。この場合は制御用の`enable_ebs`変数は不要になります。
