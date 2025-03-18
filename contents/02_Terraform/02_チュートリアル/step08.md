# モジュール間で変数を共有する

Terraformでは、output.tf を使って、モジュール間で変数（リソースの属性や値）を共有できます。
これは、モジュールの実行結果を外部で参照できるようにし、他のモジュールや環境設定ファイルでその値を利用できるようにするために非常に便利です。

以下では、output.tf の使用方法とメリットについて説明します。

## output.tf を用いるメリット

1. モジュール間での変数の共有

    モジュール内で定義されたリソースの値や属性を他のモジュールに渡す場合、output.tf によってその値を出力できます。これにより、あるモジュールで作成されたリソースの情報（たとえば、VPCのIDやサブネットのIDなど）を他のモジュールで再利用することが可能です。

    たとえば、VPCを作成するモジュールでVPCのIDを出力し、そのIDをEC2インスタンスの作成モジュールで利用するというパターンが一般的です。

1. 実行時の結果確認

    terraform apply や terraform output コマンドを実行すると、output.tf に定義された値が表示されます。これにより、作成されたリソースのIDや属性をすぐに確認でき、デバッグや運用が容易になります。これらの出力は、Terraformの状態ファイルに保存されるため、後からでも確認できます。

## output.tf ファイルを作成する

次に、具体的なコード例を示します。ここでは、VPCを作成するモジュールからVPCのIDを出力し、別のモジュールでその値を利用する方法を説明します。

`modules/network/output.tf`

以下は、VPCモジュールで作成されたVPCのIDを出力する例です。

```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}
```

- `output`ブロック内で`vpc_id`という名前の出力変数を定義しています。
- `aws_vpc.this.id`は、モジュール内で作成されたVPCのIDです。このIDが他のモジュールやファイルから参照できるようになります。

### 出力された値の利用

次に、この vpc_id を他のモジュールで利用する方法を説明します。

たとえば、サブネットを作成する際にVPCのIDを使用する場合、次のようにします。

`env/dev/network/main.tf`

```hcl
module "network" {
  source = "../modules/network"

  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = module.network.vpc_id

  ・・・
}
```

- module.vpc.vpc_id で、VPCモジュールから出力されたVPC IDを取得しています。
- このIDは、EC2モジュールでVPCに関連する設定（例: サブネットやセキュリティグループ）に使われます。

このようにして、output.tf を活用して、モジュール間でリソースの属性を柔軟に共有できます。

---

- [前のページに戻る](step07.md)
- [目次](README.md#目次)
- [次のページに進む](step09.md)
