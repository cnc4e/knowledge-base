# リソースの命名規則やタグの追加について

AWSや他のクラウドプロバイダーでは、一部のリソースに対してユニークな名前を要求するサービスがあります。たとえば、S3バケットやIAMロールはグローバルに一意の名前を持たなければなりません。このため、組織やプロジェクトごとに命名規則を定めることが重要です。これにより、リソースが適切に管理され、衝突や重複を避けることができます。

## リソースの命名規則の例

リソースの命名規則は、リソースの用途や環境に応じて適切な名前を付けるためのルールです。たとえば、次のような命名規則がよく使われます。

- プロジェクト名-環境-リソースタイプ

    例: myapp-prod-vpc, myapp-dev-ec2

- 環境-チーム名-リソース名

    例: prod-network-vpc, dev-infra-ec2

- 日付やバージョンを含める

    例: backup-20241015-s3, v1-api-gateway

命名規則を統一することで、リソースが何のために存在しているのか、どのプロジェクトや環境に属しているのかが一目でわかるようになり、管理がしやすくなります。

## タグを付ける目的

リソースに タグ を付けることは、AWSコンソールやCLIでの管理において非常に重要です。以下のような理由があります。

- 視認性の向上

    AWSリソースはIDなどのランダムな文字列で管理されるため、コンソール上での識別が困難です。タグを付けることで、リソースを簡単に特定できます。

- 管理の容易さ

    リソースが多くなると、どのリソースがどの用途に使われているか混乱しがちです。タグを適切に設定することで、チーム内でのリソース管理がスムーズになります。

- 自動化ツールやスクリプトでの利用

    タグ付けされたリソースは、自動化ツールやスクリプトでフィルタリングや操作が容易になります。これにより、特定のリソースに対する操作が効率的に行えます。

## 実際のコードにタグを追加する

これまでに作成したTerraformコードに一般的によく設定されるNameタグを追加します。  
Nameタグに設定する値は`config.yaml`で定義されている値を用いて、`env/dev/network/main.tf`で設定します。

`modules/network/main.tf`

```hcl
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name   # Nameタグを追加
  }
}
```

`modules/network/variables.tf`

```hcl
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC, used as the Name tag"
  type        = string
}
```

`/env/dev/config.yaml`

```yaml
common:
  env_name: dev
  pj_name: my-project
  region: ap-southeast-2

network:
  vpc_cidr_block: 10.0.0.0/16
```

`env/dev/network/main.tf`

`/env/dev/config.yaml`の`pj_name: my-project`の値を用いて`vpc_name`を以下のように定義します。

```hcl
module "network" {
  source = "../modules/network"

  cidr_block = local.config.network.vpc_cidr_block
  vpc_name   = "${local.config.common.pj_name}-${local.config.common.env_name}-vpc"
}
```

---

- [前のページに戻る](step06.md)
- [目次](README.md#目次)
- [次のページに進む](step08.md)
