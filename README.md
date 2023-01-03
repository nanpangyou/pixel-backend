# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

初始化命令

```shell

gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
bundle config mirror.https://rubygems.org https://gems.ruby-china.com
gem install rails -v 7.0.2.3
pacman -S postgresql-libs
cd ~/repos
rails new --api --database=postgresql --skip-test pixel-backend
code pixel-backend
// 新建终端
// 启动项目
bundle exe rails server
// 也可以用以下的命令
bin/rails s
// 需要关闭 server 请按 Ctrl + C

```

启动数据库

```shell
docker run -d      --name db-for-pixel      -e POSTGRES_USER=pixel      -e POSTGRES_PASSWORD=123456      -e POSTGRES_DB=pixel_dev      -e PGDATA=/var/lib/postgresql/data/pgdata      -v pixel-data:/var/lib/postgresql/data      --network=network1      postgres:14
```

Rails 提供的工具

建模工具：`bin/rails g model user email:string name:string`
数据库操作工具：`ActiveRecord::Migration`
同步到数据库：`bin/rails db:migrate`
反悔命令：`bin/rails  db:rollback step=1`


创建路由

```ruby
# config/routes.rb
get '/users/:id', to: 'users#show'
post '/users/', to: 'users#create'
```