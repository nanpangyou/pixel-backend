class AutoJwt
  def initialize(app)
    # 初始化时执行的代码
    @app = app
  end

  def call(env)
    # 中间件被调用的时候执行的代码

    # 如果请求路径为 /api/v1/sessions, /api/v1/validataion_codes, / 则跳过jwt检查, 前面是一个数组，如果他包含了请求的路径则直接跳过
    return @app.call(env) if ["/", "/api/v1/session", "/api/v1/validation_codes"].include? env["PATH_INFO"]

    # 将userId存入env中
    # 从请求头中获取token
    token = env["HTTP_AUTHORIZATION"].split(" ").last rescue ""
    # 解码token
    begin
      decoded_token = JWT.decode token, Rails.application.credentials.hmac_secret, true, { algorithm: "HS256" }
    rescue JWT::ExpiredSignature
      return [401, {}, [JSON.generate({ data: "登录已过期" })]]
    rescue
      return [401, {}, [JSON.generate({ data: "token无效" })]]
    end
    # 获取用户id
    userId = decoded_token[0]["userId"] rescue nil
    env["current_user_id"] = userId
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end
