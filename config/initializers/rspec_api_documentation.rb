# 添加此处配置为了解决生成的接口文档返回为[binary code]而不是对应的json
# 参考链接: https://github.com/zipmark/rspec_api_documentation/issues/456#issuecomment-597671587
module RspecApiDocumentation
  class RackTestClient < ClientBase
    def response_body
      last_response.body.encode("utf-8")
    end
  end
end
