# バージョン定義の管理を楽にする

Terraformや各種プロバイダーはバージョンアップによる仕様変更で既存コードを正常に実行できなくなる可能性があるため、以下のように動作可能なバージョンをコードに定義することで動作保証するようになっています。

```hcl
terraform {
  required_version = "= 1.8.5"

  required_providers {
    aws = {
      version = "= 5.58.0"
      source  = "hashicorp/aws"
    }
  }
}
```

ただし、この定義はディレクトリ（≒モジュール）ごとに行う必要があり、バージョンアップ対応等でまとめて定義を変更したくなった場合はすべての記述を書き換えなければならないため、操作や管理が煩雑になってしまうという問題があります。  
この問題を解決するツールとして、シンプルな操作でルートディレクトリ配下の定義をまとめて書き換えてくれるtfupdateがあります。

## tfupdateとは

tfupdateは、Terraformコード内のバージョン定義を簡単に更新できるコマンドラインツールです。  
Terraformやプロバイダーのバージョンを指定して更新し、複数のファイルを漏れなく効率的に書き換えることができます。

### tfupdateのインストール

tfupdateのインストール手順は、[公式GitHub](https://github.com/minamijoyo/tfupdate)リポジトリを参照してください。

### tfupdateの使い方

以下は、tfupdateを利用してTerraformやプロバイダーのバージョンを更新する手順です。

#### ディレクトリ構成例

プロジェクトのディレクトリ構成と、バージョン定義を記載しているファイル例です。

```plaintext
project/
├── module-a/
│   └── main.tf
└── module-b/
    └── main.tf
```

`module-a/main.tf`の内容:

```hcl
terraform {
  required_version = "= 1.0.0"

  required_providers {
    aws = {
      version = "= 3.0.0"
      source  = "hashicorp/aws"
    }
  }
}
```

#### tfupdateの実行

次のコマンドを実行して、Terraformやプロバイダーのバージョンを更新します。

```bash
tfupdate terraform --version 1.5.0 .
tfupdate provider aws --version 5.10.0 .
```

#### 実行結果

更新後、`module-a/main.tf`の内容が以下のように変わります。

```hcl
terraform {
  required_version = "= 1.5.0"

  required_providers {
    aws = {
      version = "= 5.10.0"
      source  = "hashicorp/aws"
    }
  }
}
```

このように、複数ファイルのバージョン定義を一括して更新できます。

## 運用での使い方

プロジェクトで使用するTerraformやプロバイダーのバージョンは基本的に統一して固定し、環境依存による誤動作等が起こることを防ぎます。  
ただし、Terraformやプロバイダーは頻繁に新しいバージョンがリリースされるため、定期的なバージョンアップ対応が必要になります。  
とくに開発中は古いバージョンを利用し続けるメリットはないため、高頻度で新しいバージョンでの動作確認を行う場合が多くなると思われます。  
手動更新は煩雑ですが、tfupdateを利用することで漏れを防ぎ、効率的に更新作業を行えます。

tfupdateを利用すると、すべての変更内容をGitで確認できます。  
以下はgit diffの出力例です：

```diff
- required_version = "= 1.0.0"
+ required_version = "= 1.5.0"
- version = "= 3.0.0"
+ version = "= 5.10.0"
```

---

- [前のページに戻る](README.md)
- [目次](README.md#目次)
- [次のページに進む](step02.md)
