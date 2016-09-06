# A Virtual Machine for Internship Program at Shimane Development Office

## Introduction

Ruby（Ruby on Rails／Sinatra）の開発環境を構築するためのVMです。

## Requirements

実行には以下のツールが必要なので、事前にインストールしてください。

* [Git](https://git-scm.com/)

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

## How To Build The Virtual Machine

コマンドラインで以下のコマンドを実行してください。

    host $ git clone https://github.com/shogo-mitomo/rails-dev-box.git
    host $ cd rails-dev-box
    host $ vagrant up

構築が完了したら、以下のコマンドでVMにアクセスできるようになります。

    host $ vagrant ssh

## What's In The Box

* Development tools

* Git

* Ruby 2.3

* Bundler

* SQLite3

* System dependencies for nokogiri and sqlite3

* An ExecJS runtime

## Recommended Workflow

オススメの作業方法は、以下のような形です。

* VM側でアプリケーションを起動

* ホスト側でファイルを編集・動作確認

Vagrantがホスト側の _rails-dev-box_ ディレクトリをVM側の _/vagrant_ にマウントしてくれます。

    host $ mkdir rails sinatra
    host $ vagrant ssh
    vagrant@rails-dev-box:~$ ls /vagrant
    bootstrap.sh MIT-LICENSE rails README.md sinatra Vagrantfile

以下のようにアプリケーションを起動することで、ホスト側のブラウザから `localhost:3000` でアクセスできます。

    vagrant@rails-dev-box:/vagrant/rails$ rails server -b 0.0.0.0 # Ruby on Railsの場合
    vagrant@rails-dev-box:/vagrant/sinatra$ ruby main.rb -o 0.0.0.0 # Sinatraの場合

## Virtual Machine Management

    host $ vagrant up      # 起動
    host $ vagrant halt    # 停止
    host $ vagrant status  # 状態表示
    host $ vagrant destroy # 削除

詳細は [Vagrantのドキュメント](http://docs.vagrantup.com/v2/) を参照してください。
