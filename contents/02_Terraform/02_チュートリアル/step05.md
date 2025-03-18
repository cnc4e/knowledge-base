# VPCモジュールの作成

このセクションでは、Terraformを使ってAWSにVPCを作成する手順を説明します。

## Terraformコードを作成する

以下のディレクトリ構成でそれぞれのファイルを作成してください。

### ディレクトリ構成

```text
/
├── env/
│   └── dev/
│       └── network/
│           ├── main.tf
│           ├── provider.tf
│           └── versions.tf
└── modules/
    └── network/
        ├── main.tf
        └── variables.tf
```

### Terraformコード

`env/dev/network/provider.tf`

```hcl
provider "aws" {
  region = "ap-southeast-2"
}
```

`env/dev/network/versions.tf`

```hcl
terraform {
  required_version = ">= 1.0.0"

  # 先に作成したTerraformの状態管理用S3バケットを指定
  backend "s3" {
    bucket = "my-project-dev-tfstate-bucket"
    key    = "terraform/vpc.tfstate"
    region = "ap-southeast-2"
  }
}
```

`modules/network/main.tf`

AWSのVPCを作成するリソース aws_vpc を定義しています。このリソースは、変数 vpc_name で指定された名前と cidr_block で指定されたIPアドレス範囲を使用してVPCを作成します。

```hcl
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
}
```

`modules/network/variables.tf`

VPC名とCIDRブロックを外部から受け取るための変数が定義されています。これにより、柔軟にVPCの設定を変更できます。

```hcl
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}
```

`env/dev/network/main.tf`

VPCモジュールを呼び出すためのコードです。モジュールは modules/network 内に定義されており、VPC名 (vpc_name) とCIDRブロック (cidr_block) を指定しています。

```hcl
module "network" {
  source = "../modules/network"

  cidr_block = "10.0.0.0/16"
}
```

## リソースを作成する

### リソースの作成手順

1. Terraformの初期化

    初回実行時の場合、Terraformで必要なプロバイダをインストールするために以下を実行します。

    ```bash
    terraform init
    ```

1. リソースのプラン確認

    実際にリソースを作成する前に、どのようなリソースが作成されるかを確認します。

    ```bash
    terraform plan
    ```

1. リソースの作成

    VPCを作成するために以下を実行します。

    ```bash
    terraform apply
    ```

    実行後に確認を求められるため、yes を入力して実行を続けます。

1. 作成されたVPCの確認

AWSコンソールの「VPC」サービスから、作成されたVPCが表示されるか確認します。VPC名やCIDRブロックが正しいかどうかをチェックします。

### リソースの削除手順

この後の手順でVPCを作り直すため、作成したVPCを一旦削除します。

1. リソースの削除

    作成したVPCなどのリソースを削除するには、以下を実行します。

    ```bash
    terraform destroy
    ```

    実行後に確認を求められるため、yes を入力してリソースの削除を完了します。

これで、Terraformを使ったVPCの作成および削除の手順が完了します。

---

- [前のページに戻る](step04.md)
- [目次](README.md#目次)
- [次のページに進む](step06.md)
