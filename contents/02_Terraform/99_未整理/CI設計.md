# CIについて

GitLabにはCIの機能が内蔵されており、事前にCIのセットアップを行っておくことで[.gitlab-ci.yml](/.gitlab-ci.yml)に定義した処理をPush時やマージ時などに自動で実行させられるようにできます。  
作り込むことでMRをマージしたときに本番環境にTerraformを実行するなどの処理を実行させることも可能ですが、今回はPushされたコードの静的解析を行って簡易的なテストを行う処理だけを実装しています。  
実装しているテストは以下の通りです。いずれもチェックのみで、自動的に修正することはしていません。

## 構文チェック

### インデントやスペースが適切な書き方になっているかのチェック

Terraformはインデントやスペース数がバラバラでも動作に問題はありませんが、`terraform fmt`というコマンドで自動的にコードを整形してくれるため、コードに統一性を持たせるために実装しています。  
このテストがNGになった場合はコードが整形されていない（`terraform fmt`を実行していない）ということになります。  
Pushするまえにリポジトリのトップディレクトリで`terraform fmt -recursive`コマンドを実行するように意識してください。  
`-recursive`オプションを付けることで再帰的にカレントディレクトリ以下のすべてのディレクトリのTFファイルを整形してくれます。

### コードルールの静的解析

[tflint](https://github.com/terraform-linters/tflint)というツールを使って文法的に間違っているコードがないかを確認しています。  
基本的にPush前に`terraform apply`や`terraform plam`を行って正常に実行できていればこのテストは成功します。  
失敗した場合はローカルで上記コマンドを実行して原因を解決してから再度Pushしてください。

### ドキュメント生成チェック

[doc/module](/doc/module/)にモジュールごとの簡易的なドキュメントを作成していますが、これらは[terraform-docs](https://github.com/terraform-docs/terraform-docs)というツールを使ってコードから自動的に生成したファイルになります。  
このテストではコードを変更した後にドキュメントの自動生成を行ってドキュメントも最新化しているかどうかのチェックをしています。  
失敗した場合はドキュメントを再生成してPushしてください。  
ドキュメントの生成方法は[こちら](./ドキュメント設計.md)を参照してください。  
なお、コード変更時は関係性の図も更新した方が望ましいですが、こちらはチェックが難しいためテストは実装していません。  
自主的に忘れないように意識したりレビュアーが指摘する等で忘れないように気を付けてください。
