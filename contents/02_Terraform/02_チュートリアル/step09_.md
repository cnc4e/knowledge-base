# 実行済みのTerraformのtfstateの値を参照する

Terraformでは、他の環境やモジュールで管理されているリソースの`tfstate`に出力された`output`値を参照し、新しいリソースを作成することが可能です。この方法を利用することで、複数のTerraformプロジェクトやモジュール間でのリソース連携を効率的に行えます。

## `remote_state`の使用

### 参照元モジュールでのoutputの定義

まず参照元のモジュールや環境で、必要な値を`output`として定義します。

`network`モジュールでVPCのIDを出力する場合：

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

この`output`は、モジュール実行後に生成される`tfstate`に保存されます。

### 参照先での設定

別の環境やモジュールでこの`vpc_id`を利用するには、`remote_state`データソースを使います。

```hcl
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "my-project-dev-tfstate-bucket"  # 参照するS3バケット
    key    = "network/terraform.tfstate"  # tfstateファイルのパス
    region = "ap-southeast-2"             # S3バケットのリージョン
  }
}

resource "aws_subnet" "main" {
  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
}
```

1. `terraform_remote_state`データソースの定義

    `data "terraform_remote_state"`を使用し、参照したい`tfstate`ファイルの情報を設定します。

1. S3バケットと`tfstate`ファイルの指定

    `config`ブロック内で、`tfstate`ファイルが保存されているS3バケットやファイルパス、リージョンを指定します。

1. output値の取得と利用

    `data.terraform_remote_state.<name>.outputs.<output_name>`で、参照元のoutput値を取得し、リソース作成時に使用します。
