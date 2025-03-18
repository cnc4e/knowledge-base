# コード品質向上とセキュリティチェックを効率化する

## Terraform単体運用の課題

Terraformを単体で運用する場合、コード管理やセキュリティ面で以下のような課題が生じることがあります：

1. 構文エラーや記述ミスの見落とし

   Terraformコードが正しく書かれていないと、実行時にエラーが発生します。  
   しかし、Terraformでは実際に`terraform plan`や`terraform apply`を実行するまで多くのミスが検出されません。このため、ミスを発見するのが遅れ、余計な時間がかかります。

1. ベストプラクティスの遵守が難しい

   複雑なインフラ構成では、リソース名の命名規則や推奨設定を守ることが難しく、チーム全体でのコード品質の維持が課題となります。

1. セキュリティリスクの見逃し

   たとえば、S3バケットの公開設定やIAMロールの過剰な権限設定など、コードに潜むセキュリティリスクが見落とされ、本番環境にリスクが持ち込まれる可能性があります。

1. コードレビューの負担

   チームで運用する場合、手作業でのコードレビューに多くの時間が取られ、すべての潜在的な問題を網羅するのが難しくなります。

## 効率化のためのポイント

Terraformの運用を効率化するには以下のポイントが重要です：

1. コードの静的解析

   実行前に構文や設定ミスを自動的に検出し、ムダなトラブルシューティングを防ぎます。

1. ベストプラクティスの強制

   規約違反や不適切な設定を自動で検出し、チーム全体で一貫性のあるコード品質を確保します。

1. セキュリティチェックの自動化

   セキュリティリスクの検出を自動化し、開発スピードを損なうことなく安全性を高めます。

1. CI/CDパイプラインへの統合

   静的解析やセキュリティチェックをコード変更時に自動実行し、レビュー負担を軽減します。

これらのポイントを実現するためのツールとして、コードの静的解析を行うtflintやセキュリティスキャンを行うtfsecがあります。

## tflintでコード品質を向上させる

### tflintの特徴とメリット

- 構文チェックとベストプラクティスの遵守

   tflintはTerraformコードの静的解析を行い、構文エラーや不要なリソースを検出します。また、プロバイダー固有の推奨設定もチェックできるため、コードのベストプラクティスを守ることが容易になります。

- プラグインによる柔軟な解析

   AWSやGCPなど、プロバイダーごとに特化したルールを追加でき、プロジェクトの要件に応じたチェックが可能です。

### tflintのインストール

tflintのインストール手順：

1. Homebrewを利用する場合：

   ```bash
   brew install tflint
   ```

2. バイナリを直接ダウンロードする場合：

   [公式GitHubリポジトリ](https://github.com/terraform-linters/tflint)を参照してください。

### tflintの実行結果例

以下のようなTerraformコードを作成したとします。  
このコードには複数の問題が含まれているため、tflintを実行すると問題点が指摘されます。

```hcl
variable "example" {
  description = "An example variable"
  type        = string
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.invalid"  // 無効なインスタンスタイプ

  tags = {
    Name = "example-instance"
  }
}

resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // ポート22への無制限のインバウンドアクセス
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

プロジェクトのルートディレクトリで以下のコマンドを実行します。

```bash
tflint
```

以下のように問題となる箇所が出力されるため、修正箇所の特定が容易となります。

```bash
3 issues found:

1. [ERROR] aws_instance_invalid_type: Invalid instance type
2. [WARNING] unused_variable: Variable 'example' is declared but not used
3. [ERROR] aws_security_group_unrestricted_ingress: Security group allows unrestricted ingress on port 22
```

### tfsecでセキュリティチェックを効率化する

### tfsecの特徴とメリット

- セキュリティリスクの早期発見

   tfsecはTerraformコードのセキュリティスキャンを行い、たとえば未暗号化のリソースやパブリックアクセスの設定ミスなどを検出します。

- コンプライアンス対応

   SOC 2やPCI DSSなどのセキュリティ要件に準拠したチェックが可能で、監査対応をスムーズにします。

### tfsecのインストール

tfsecのインストール手順：

1. Homebrewを利用する場合：

   ```bash
   brew install tfsec
   ```

2. バイナリを直接ダウンロードする場合：

   [公式GitHubリポジトリ](https://github.com/aquasecurity/tfsec)を参照してください。

### tfsecの実行結果例

以下のようなTerraformコードを作成したとします。  
このコードにはセキュリティ上の問題が含まれているため、tfsecを実行すると問題点が指摘されます。

```hcl
variable "example" {
  description = "An example variable"
  type        = string
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}

resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // ポート22への無制限のインバウンドアクセス
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

プロジェクトのルートディレクトリで以下のコマンドを実行します。

```bash
tfsec
```

セキュリティ上のリスクとなるコードについて出力されます。

```bash
Result:

  [AWS017][HIGH] Resource 'aws_security_group.example' allows ingress from 0.0.0.0/0 on port 22
  /path/to/terraform/code/main.tf:12-18

      9 |   ingress {
     10 |     from_port   = 22
     11 |     to_port     = 22
     12 |     protocol    = "tcp"
     13 |     cidr_blocks = ["0.0.0.0/0"]
     14 |   }

  Impact:    The port is exposed for ingress from the internet
  Resolution: Set a more restrictive cidr range

  More Info:
  https://tfsec.dev/docs/aws/AWS017/
```

このように、tfsecを使用することでTerraformコードのセキュリティリスクを事前に検出し、修正ができます。

## tflintとtfsecの運用での使い方

tflintやtfsecによる静的解析を行うことで、コードに一定の品質の担保ができます。
また、GiHub ActionsやGitLab CI等で静的解析によるチェックを自動化し、正常に通過したことをMRに出す条件とすることで、レビュー負担の軽減やリードタイムの短縮が見込めます。

## まとめ

静的解析を行うことで、見逃していたコードの不備やリスクのある設計に気付くことができます。
さらに、これらをCIに組み込むと検知が自動化され、レビューの負担軽減やリードタイムの短縮などの効果も見込めます。
実際に作成したリソースからリスクを検知して修正するのは手間のかかる作業になりますが、コード化して静的解析を実行することで、リソースを作成する前に気付いて修正することが可能になります。

---

- [前のページに戻る](step01.md)
- [目次](README.md#目次)
- [次のページに進む](step03.md)
