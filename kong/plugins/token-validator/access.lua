local responses = require "kong.tools.responses"

local _M = {}

local function extract_auth_token(config)
  return ngx.req.get_headers()[config.header]
end

local function token_empty(token)
  if token == nil or #token <= 0 then
    return true
  end
  return false
end

function _M.execute(config)
  local auth_token = extract_auth_token(config)

  -- Return 401 Unauthorized if token is missing or empty
  if token_empty(auth_token) then
    ngx.ctx.stop_phases = true
    return responses.send_HTTP_UNAUTHORIZED()
  end
end

return _M
