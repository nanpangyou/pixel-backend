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

或者`bin/rails g controller api/v1/mes_controller`来创建`/api/v1`下的路由


路由使用`pagy`[pagy](https://github.com/ddnexus/pagy),也可以看看`Kaminari`[Kaminari](https://github.com/kaminari/kaminari)


```ruby
  def index
    page = params[:page]
    pageSize = params[:size]
    @pagy, @xx = pagy(Item, page: page, items: pageSize)

    render json: { page: @pagy, records: @xx }
  end
```


安装单元测试库`Rspec`[Rspace](https://github.com/rspec/rspec-rails/tree/6-0-maintenance)

```
# 在gemfile里添加gem
# Run against this stable release
group :development, :test do
  gem 'rspec-rails', '~> 6.0.0'
end


# 使用bundle安装
# Download and install
$ bundle install

# Generate boilerplate configuration files
# (check the comments in each generated file for more information)
# 初始化
$ rails generate rspec:install
```

```shell
# 针对user生成对于 model 的测试
rails generate rspec:model user
```
```ruby
# spec/models/user_spec.rb

require "rails_helper"

RSpec.describe User, type: :model do
  it "有 email" do
    user = User.new name: "Lewis", email: "yi@163.com"
    expect(user.email).to eq "yi@163.com"
  end
end

```

还要创建测试使用的数据库

在 config/datebase.yml 下增加测试数据库的配置
```yml

test:
  <<: *default
  database: pixel_test
  username: pixel
  password: 123456
  host: db-for-pixel

```

然后使用 rails 创建测试数据库
```shell

# 需要在执行前添加 RAILS_ENV=test 的环境变量
# 创建测试数据库
RAILS_ENV=test bin/rails db:create  
# 创建表
RAILS_ENV=test bin/rails db:migrate
```

然后可以使用以下代码跑所有的测试用例
```shell

bundle exec rspec

```

测试请求可以使用 rspec request 
```shell
# 生成 spec/requests/items_spec.rb 文件
rails g rspec:request items
```


rails 自带了可以在命令行里运行简单代码的方法： `rails console`,如果想刷新变量重置环境则输入 `reload!`


# 部署过程

1. 创建打包脚本 `./bin/pack_for_host.sh`
2. 修改可执行权限 `chmod -x ./bin/pack_for_host.sh`
3. 添加Dockerfile `./config/host.Dockerfile`
4. 添加运行docker的脚本 `./bin/setup_host.sh`
5. 给脚本都添加可执行权限 `chmod +x ./bin/*.sh`
6. 执行打包脚本 `bin/pack_for_host.sh`

7. 创建密钥 `bin/rails credentials:edit` => 会创建一个临时文件，生成一个key(你也可以修改)，关闭后生成两个文件( master.key, credentials.yml.enc)
8. 如何读取key们
   1. 打开控制台，输入 `bin/rails console`
   2. 输入`Rails.application.credentials.key的名字`来获取特定名字的key
   3. 输入`Rails.application.credentials.config` 来获取所有的key
   4. 如果想修改，则在执行一遍`bin/rails credentials:edit`
9. 创建生产环境的密钥 `bin/rails credentials:edit --environment production`
10. 读取生产环境的key们
   1. 打开控制台，输入`RAILS_ENV=production bin/rails console`
   2. 输入`Rails.application.credentials.key的名字`来获取特定名字的key
   3. 输入`Rails.application.credentials.config` 来获取所有的key
   4. 如果想修改，则在执行一遍`RAILS_ENV=production bin/rails credentials:edit`

11. 在`setup_host.sh`中`docker run`中添加` -e RAILS_MASTER_KEY=$RAILS_MASTER_KEY `
12. 在宿主机执行`setup_host.sh`时，`RAILS_MASTER_KEY=在config/credentials/production.key的内容 pixel_backend_deploy/setup_host.sh`
13. 新建`bin/pack_for_remote.sh`和`bin/setup_remote.sh`
14. 运行`bin/pack_for_remote.sh`

# 添加邮件功能
[文档](https://guides.rubyonrails.org/action_mailer_basics.html)

# 数据库设计辅助网站
[dbdiagram](https://dbdiagram.io/)

# TDD

1. 安装`rspec_api_documentation` 用来自动生成api文档（github搜索，安装）  
2. 按照`rspec_api_documentation` 文档来完成api文档的自动生成,生成文档`bin/rake docs:generate`
3. 配置生成的config 使得入参反参均为`json`


可以在`bin/rails c`控制台中使用`ValidationCode.destroy_all`可以清空`validation_codes`表中的数据



## 中间件

`bin/rails middleware` 列出所有的中间件
其他添加删除等见[链接](https://guides.rubyonrails.org/rails_on_rack.html)



# 快速实现Api接口

get /api/v1/tags

1. 创建`model`
2. 运行`db:migrate`
3. 创建`controller`
4. 写测试
5. 写代码
6. 写文档