# モジュールのドキュメントを効率的に作成する

Terraformモジュールにはそのモジュールを説明するドキュメントを作成することが望ましいです。
ただし、コードは開発や運用が進むごとに変化していくものであり、その都度作成されるリソースのリストや変数の説明などを更新していくのはとても非効率的です。
こうした課題に対処するためのツールとしてterraform-docsがあります。このツールは、Terraformコードから必要な情報を抽出して、変数や出力、リソースの詳細を整理したドキュメントを自動で生成します。

## terraform-docsについて

terraform-docsは、`variables.tf`や`outputs.tf`に記載された変数や出力の情報を解析し、それをMarkdownやJSON、YAML形式で整理します。チーム全体で統一された形式のドキュメントを生成し、読みやすさを確保します。また、Terraformコードの変更に応じて、自動でドキュメントを更新できるため、常に正確な情報を提供します。

以下は、リソース、変数、outputを含んだ簡易のTerraformコードの例です。

`variables.tf`:

```hcl
variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t2.micro"
}
```

`main.tf`:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  tags = {
    Name = "example-instance"
  }
}
```

`outputs.tf`:

```hcl
output "instance_id" {
  description = "The ID of the example instance"
  value       = aws_instance.example.id
}
```

### 実際に生成されるドキュメント

以下は、上記のTerraformコードから生成されるドキュメントの例です。

```md
## 変数

| 名前           | 説明                           | タイプ   | デフォルト値 |
|----------------|--------------------------------|----------|--------------|
| instance_type  | The type of instance to create | string   | t2.micro     |

## リソース

| 名前           | タイプ         |
|----------------|----------------|
| aws_instance.example | aws_instance |

## 出力

| 名前         | 説明                           | 値                        |
|--------------|--------------------------------|---------------------------|
| instance_id  | The ID of the example instance | aws_instance.example.id   |
```

### terraform-docsの導入と使い方

#### インストール

terraform-docsは以下の手順でインストールできます：

- macOS（Homebrew）

    ```bash
    brew install terraform-docs
    ```

- Linux

    ```bash
    curl -sSLo /usr/local/bin/terraform-docs https://github.com/terraform-docs/terraform-docs/releases/latest/download/terraform-docs-linux-amd64
    chmod +x /usr/local/bin/terraform-docs
    ```

詳細は[公式ドキュメント](https://github.com/terraform-docs/terraform-docs)を参照してください。

#### 使用例

terraform-docsを使って、プロジェクトのルートディレクトリ内でドキュメントを生成します。

Markdown形式のドキュメント生成:

```bash
terraform-docs markdown --output-file README.md .
```

これにより、現在のディレクトリにあるTerraformコードに基づいたREADME.mdが生成されます。

既存のREADME.mdにドキュメントを挿入する場合:

```bash
terraform-docs markdown --output-file README.md --output-mode inject .
```

これにより、既存のREADME.mdファイル内の特定のセクションにドキュメントが挿入されます。--output-mode injectオプションを使用することで、既存のドキュメントを保持しつつ、最新の情報を追加できます。

## 運用での使い方

運用では、terraform-docsをローカル環境やCI/CDパイプラインに統合して利用するのが効果的です。コードの変更が行われるたびに、terraform-docsを手動で実行して最新のドキュメントを生成し、リポジトリに反映します。CI/CDパイプラインでは、生成されたドキュメントに差分が発生していないことをチェックすることで、ドキュメントの更新漏れを防止できます。たとえば、GitHub ActionsやGitLab CIを用いて、プルリクエスト時にドキュメントの差分チェックを自動で行う仕組みを構築できます。

また、Markdown形式で生成したドキュメントをREADME.mdとしてプロジェクトリポジトリに配置すれば、チーム全員が簡単にモジュールの仕様を把握できるようになります。これにより、コードレビューや設計時の手間が大幅に軽減されます。

## まとめ

terraform-docsを活用すれば、Terraformコードのドキュメント作成や最新の状態への更新にかかる負担を大幅に軽減できます。最新のコードに基づいた正確なドキュメントを自動生成することで、コードを見なくてもモジュールで作成されるリソースや変数に与える値について確認できるようになります。

---

- [前のページに戻る](step02.md)
- [目次](README.md#目次)
- [次のページに進む](step04.md)
