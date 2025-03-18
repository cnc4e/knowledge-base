# Terraformの変数の共通化

Terraformでの変数の共通化は、複数の環境（開発、ステージング、本番など）や同一環境内で共通するリソース構成を持つ場合に便利です。これにより、重複した設定を削減し、管理をシンプルにできます。また、複数のモジュールで同一の値を使用する場合でも、共通化した変数を利用することで、一箇所で値を変更するだけで影響範囲全体を管理できるため、保守性が向上します。今回はenv/dev/network/main.tfで使用している変数をconfig.yamlに外部化し、共通化する手法を紹介します。

## 変数の共通化のメリット

1. コードの再利用性向上

    一度定義した変数を複数の環境で使い回すことができ、コードの重複を防ぎます。

2. メンテナンスの簡略化

    変数の変更が1箇所で完結するため、異なる環境ごとの設定変更の際に、各ファイルを編集する手間が減ります。

3. 環境ごとの設定の分離

    環境ごとに設定ファイルを分けることで、デプロイ先による設定の違いを簡単に切り替えることが可能です。

## YAMLファイルに変数を定義する

yamldecodeを使ってlocal変数に読み込みます。

```text
/
├── env/
│   └── dev/
│       ├── network/
│       │   ├── main.tf
│       │   ├── provider.tf
│       │   ├── versions.tf
│       │   └── locals.tf    # config.yamlを読み込む設定ファイル
│       └── config.yaml      # 共通化する変数を定義するファイル
└── modules/
```

`/env/dev/config.yaml`

まず、共通化する変数を config.yaml に定義します。

```yaml
common:
  env_name: dev
  pj_name: my-project
  region: ap-southeast-2

network:
  vpc_cidr_block: 10.0.0.0/16
```

`env/dev/network/main.tf`

```hcl
module "network" {
  source = "../modules/network"

  cidr_block = local.config.network.vpc_cidr_block
}
```

`env/dev/network/locals.tf`

最後に変数を外部ファイルから読み込むための設定を行います。  
localsを使って`config.yaml`を読み込み、その内容を変数として使用します。

```hcl
locals {
  config = yamldecode(file("../config.yaml"))
}
```

この例では、dev環境のYAMLファイルから`cidr_block`を読み込み、それを`module "vpc"`に渡しています。

---

- [前のページに戻る](step05.md)
- [目次](README.md#目次)
- [次のページに進む](step07.md)
