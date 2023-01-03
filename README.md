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


命令行功能（待查看）： 子字符串查询

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

创建 controller

```shell

 bin/rails g controller users show create
# 这个命令除了创建 controller 之外，还会创建对应的路由，但是可以在 config/routes.rb 中删除,写自己需要的路由

```

可以使用`curl`命令来测试

```shell

curl -X POST http://localhost:3000/users

curl http://localhost:3000/users/3   

# -v 可以查看详细信息 状态码之类
curl -v http://localhost:3000/users/3

```


创建路由的时候可以使用`namespace`的方式来
```ruby
  namespace :api do
    namespace :v1 do
      #/api/v1
      resources :validation_codes, only: [:create]
      resource :session, only: [:create, :destroy]
      resource :me, only: [:show]
      resources :items
      resources :tags
    end
  end

# restful对应的controller方法

  # create => post 创建记录
  # update => patch 表示部分更新
  # destroy => delete 表示删除
  # index => get /items?since=2021-01-01&before=2022-01-01 一般指返回多条数据
  # show => get /items/:id 一般只返回一条数据

```

查看对应的路由
```shell
# 创建好后执行
bin/rails routes
```


可以使用`bin/rails g controller api::v1::validation_codes`来创建`/api/v1`下的路由