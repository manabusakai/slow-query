# slow-query.sh

## About

MySQLのスロークエリ・ログをメールで送信するためのシェルスクリプトです。cronで定期実行することを想定しています。

## How to use

このシェルスクリプトを実行するには、LinuxとMySQLのroot権限が必要です。一般ユーザーでは実行できません。

### Install

パスが通っているディレクトリにシェルスクリプトを設置して、755などの実行権限を与えます。

    # ls -l /usr/local/bin/slow-query
    -rwxr-xr-x 1 root root 263  2月 19 20:20 /usr/local/bin/slow-query

### Setting

mysqladminコマンドを実行させるために、rootユーザーのパスワードを書いたファイルを用意します。

    [mysqladmin]
    user = root
    password = password

一般ユーザーが読めないように所有者とパーミッションを変更します。

    # chown root.wheel /usr/local/etc/my.cnf
    # chmod 640 /usr/local/etc/my.cnf

## Usage

    # slow-query -m foo@example.com -c /usr/local/etc/my.cnf -l /var/log/mysql/slow_query.log

コマンドに与える引数は3つです（すべて必須）。

- m : 送信先のメールアドレス
- c : Settingで用意したcnfファイル
- l : スロークエリのログファイル

crontabを設定するときは、mysqlユーザーで実行させるようにしてください。

    # crontab -u mysql -l
    0 4 * * * slow-query -m foo@example.com -c /usr/local/etc/my.cnf -l /var/log/mysql/slow_query.log 2>/dev/null