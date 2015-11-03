local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local TokenValidator = BasePlugin:extend()

function TokenValidator:new()
  print('hello from init')
  TokenValidator.super.new(self, "token-validator")
end


function TokenValidator:access(config)
  TokenValidator.super.access(self)
  -- local auth_token = ngx.header["X-Auth-Token"]
  print("-----------")
  print("hello from access")
  print(ngx)
  print(auth_token)
  print("-----------")
  -- if auth_token == nil or #auth_token <= 0 then
  --   ngx.ctx.stop_phases = true
  --   return responses.send_HTTP_UNAUTHORIZED()
  -- end
end

TokenValidator.PRIORITY = 1000

return TokenValidator
