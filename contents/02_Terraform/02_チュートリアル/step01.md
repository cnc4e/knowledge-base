# 1. 事前準備

AWSにTerraformを実行するための準備を行います。すでに完了済みの場合は不要です。

## AWSアカウントの作成

まず、AWS環境で作業を進めるためには、AWSアカウントが必要です。まだアカウントを持っていない場合は、以下の手順にしたがって作成してください。

[AWS アカウントの作成方法](https://aws.amazon.com/jp/premiumsupport/knowledge-center/create-and-activate-aws-account/)

無料でアカウントを作成する手順が詳細に説明されています。AWSは無料利用枠が提供されているため、はじめて利用する方でも特定のサービスを一定期間無料で利用できます。

## IAMユーザーの設定

AWSアカウントを作成した後は、セキュリティを強化するため、管理用のIAMユーザーを作成します。IAMユーザーは、ルートユーザーではなく、AWSのリソースに対して適切なアクセス権限を持ったユーザーで作業するために必要です。

[IAMユーザーの作成方法](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_users_create.html)を参考に、管理者権限を持つユーザーを作成してください。ルートユーザーはアカウント全体の権限を持っているため、日常の操作には利用せず、IAMユーザーを用いて作業することでセキュリティリスクを低減できます。

## アクセスキーとシークレットキーの作成

IAMユーザー作成後、そのユーザーに割り当てるアクセスキーとシークレットキーを生成します。TerraformがAWSリソースにアクセスするための認証情報として必要です。詳細な手順は[IAM ユーザーのアクセスキーを管理](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_credentials_access-keys.html)をご参照ください。

## Terraformのインストール

次に、AWSのインフラをコードとして管理するために必要なTerraformをインストールします。Terraformは、インフラの構成を簡素化し、効率的にリソースを管理するためのツールです。公式ドキュメントを参照し、使用する環境に応じてセットアップを行ってください。

[Terraformのインストールガイド](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)では、Windows、macOS、Linuxに対応したインストール手順が提供されています。最新バージョンのインストールを推奨します。

## Terraformの動作確認

実行するために必要な最低限のコードを作成します。このコードは非推奨な書き方になっているため、すでに理解している場合は省略してもよいです。

### 作業ディレクトリの作成

まず、Terraformプロジェクト用のディレクトリを作成します。

```bash
mkdir terraform-vpc-demo
cd terraform-vpc-demo
```

### VPC作成用のTerraformコード

作業ディレクトリ内で、以下のファイルを作成してください。

`your_access_key`と`your_secret_key`は、実際のAWSアカウントの認証情報に置き換えてください。  
また、1つのリージョンに同じCIDRのVPCは作成できないため、下記CIDRのVPCがすでに存在している場合は必要に応じて変更してください。

`main.tf`

```hcl
provider "aws" {
  access_key = "your_access_key"
  secret_key = "your_secret_key"
  region = "ap-southeast-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "test-vpc"
  }
}

```

このコードは、指定したAWSリージョンにVPCを作成します。cidr_blockの範囲は必要に応じて変更可能です。

### Terraformの初回実行手順

1. Terraformの初期化

    最初に、Terraformが必要なプロバイダやモジュールを取得できるよう、プロジェクトディレクトリで以下のコマンドを実行して初期化します。

    ```bash
    terraform init
    ```

2. Terraformのプラン確認

    実行前に、どのリソースが作成されるかを確認するために以下のコマンドを実行します。

    ```hcl
    terraform plan
    ```

3. Terraformの適用

    プランが問題ない場合、実際にVPCを作成するために以下を実行します。

    ```hcl
    terraform apply
    ```

    terraform apply 実行時に確認プロンプトが表示されると、以下のようなメッセージが出力され、続行のために yes の入力が求められます。  
    yes と入力すると処理が続行され、それ以外の入力をすると処理がキャンセルされます。

    ```plaintext
    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: yes
    ```

### 動作確認

以下の手順でAWSマネジメントコンソールから正しくVPCが作成できたか確認してください。

1. AWSコンソールにログイン

    AWSアカウントにログインし、トップ画面の検索バーで「VPC」を検索し、VPCサービスを選択します。

1. VPCの一覧を確認

    VPCダッシュボードの「Your VPCs」（VPC）をクリックして、リージョン内にあるすべてのVPCを表示します。

1. 作成されたVPCを確認

    一覧から「Name: main-vpc」のタグが付いたVPCを探します。CIDRブロックが10.0.0.0/16であることを確認します。

1. 詳細の確認

    作成されたVPCの詳細ページで、VPC IDやタグ情報などが正しいか確認します。

これで、Terraformで作成したVPCがAWSコンソール上に表示され、正しく作成されたか確認できます。

---

- [前のページに戻る](README.md)
- [目次](README.md#目次)
- [次のページに進む](step02.md)
