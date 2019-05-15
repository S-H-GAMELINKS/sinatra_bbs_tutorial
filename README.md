# Sinatraでの掲示板アプリ

[sinatra](https://github.com/sinatra/sinatra/)を使った非常に簡単な掲示板アプリのチュートリアルです

# チュートリアル
## Sinatraのインストール

まずは`sinatra`をインストールします

```shell
gem install sinatra sinatra-contrib
```

その後、デスクトップに`sinatra_bbs`ディレクトリを作成します

```shell
mkdir sinatra_bbs
```

ディレクトリ作成後、`sinatra_bbs`へと移動します

```shell
cd sinatra_bbs
```

## Hello World!

`sinatra_bbs`内に`main.rb`を以下のように作成します

```ruby:main.rb
require 'sinatra'
require 'sinatra/reloader'

get '/' do
    'Hello World!'
end 
```

`main.rb`作成後、ターミナルで`ruby main.rb`を実行します

```shell
ruby main.rb
```

その後、ブラウザのアドレスバーに`localhost:4567`を入力します 
`Hello World!`と表示されていればOKです！

## テンプレートを使う

`sinatra`では`erb`などのテンプレートを使うことができます 
今回は`erb`を使って`Hello World!`と表示してみます 

まずは`views`ディレクトリを`sinatra_bbs`内に作成します

```shell
mkdir views
```

その後、`views`ディレクトリ内に`index.erb`を作成し、以下のようにします

```erb:views/index.erb
<html>
    <body>
        Hello World!
    </body>
</html> 
```

あとは、`main.rb`を以下のように修正して`ruby main.rb`を実行します

```ruby:main.rb
require 'sinatra'
require 'sinatra/reloader'

get '/' do
    erb :index
end 
```

```shell
ruby main.rb
```

`localhost:4567`へと再度アクセスして、`Hello World!`と表示されていればOKです！

## 掲示板機能を実装

まずは`DB`を作成します

`import.sql`を以下のように作成します

```sql:import.sql
create table comments(
    id integer primary key,
    body text
); 
```

次に、`sqlite3`を使い`DB`を作成します

```shell
sqlite3 bbs.db
.read import.sql
.exit
```

次に、`ActiveRecord`というデータベースとの接続をよしなにしてくれるものを使い、DBから作成されたコメントを表示できるようにします
　
まずは、`main.rb`を以下のように変更します

```ruby:main.rb
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

ActiveRecord::Base.establish_connection(
    "adapter" => "sqlite3",
    "database" => "./bbs.db"
)

class Comment < ActiveRecord::Base
end

get '/' do
    @comments = Comment.all
    erb :index
end
```

そして、`views/index.erb`を以下の変更します

```erb:views/index.erb
<html>
    <head>
        <title>Sinatra BBS</title>
    </head>
    <body>
        <h1>BBS</h1>
        <ul>
            <% @comments.each do |comment| %>
                <li>
                    <%= comment.id %>: <%= comment.body %>
                </li>
            <% end %>
        </ul>
    </body>
</html>
```

ここまでの変更で作成済みのコメントを一覧として表示することができます

最後に、コメントを作成するフォームを実装ていきます

フォームから送信されたコメントを取得して、DBに保存する処理を実装します

```ruby:main.rb
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

ActiveRecord::Base.establish_connection(
    "adapter" => "sqlite3",
    "database" => "./bbs.db"
)

class Comment < ActiveRecord::Base
end

get '/' do
    @comments = Comment.all
    erb :index
end

post '/new' do
    Comment.create({:body => params[:body]})
    redirect '/'
end
```

最後に、`views/index.erb`にコメントを作成するフォームを実装します

`views/index.erb`を以下のようにします

```erb:views/index.erb
<html>
    <head>
        <title>Sinatra BBS</title>
    </head>
    <body>
        <h1>BBS</h1>
        <ul>
            <% @comments.each do |comment| %>
                <li>
                    <%= comment.id %>: <%= comment.body %>
                </li>
            <% end %>
        </ul>
        <h2>Add New</h2>
        <form method="post" action="/new">
                <input type="text" name="body">
                <input type="submit" value="post">
        </form>
    </body>
</html>
```

後は、ターミナルで`ruby main.rb`を実行します

```shell
ruby main.rb
```

`localhost:4567`にアクセスし、フォームからコメントを送信できていればOKです！

## LISENCE

[MIT](./LISENCE)

# 参考

[Sinatra 入門](https://qiita.com/kimioka0/items/751e460cbb59c70379c6)
