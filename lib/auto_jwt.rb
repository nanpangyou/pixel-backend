class AutoJwt
  def initialize(app)
    # 初始化时执行的代码
    @app = app
  end

  def call(env)
    # 中间件被调用的时候执行的代码

    # 将userId存入env中
    # 从请求头中获取token
    token = env["HTTP_AUTHORIZATION"].split(" ").last rescue ""
    # 解码token
    decoded_token = JWT.decode token, Rails.application.credentials.hmac_secret, true, { algorithm: "HS256" } rescue nil
    # 获取用户id
    userId = decoded_token[0]["userId"] rescue nil
    env["current_user_id"] = userId
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end
