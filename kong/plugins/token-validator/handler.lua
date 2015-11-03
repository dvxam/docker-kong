local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.token-validator.access"

local TokenValidator = BasePlugin:extend()

function TokenValidator:new()
  TokenValidator.super.new(self, "token-validator")
end

function TokenValidator:access(config)
  TokenValidator.super.access(self)
  if config.on then
    access.execute(config)
  end
end

TokenValidator.PRIORITY = 1000

return TokenValidator
