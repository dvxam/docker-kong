local responses = require "kong.tools.responses"
local http_client = require "kong.tools.http_client"

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

local function check_token_validity(auth_token, config)
  local url = "http://mrdrive-pimp-my-auth-staging.herokuapp.com/session"
  local headers = {
    ["Content-Type"] = "application/json",
    [config.header] = auth_token
  }
  return http_client.get(url, {}, headers)
end

function _M.execute(config)
  local auth_token = extract_auth_token(config)

  -- Return 401 Unauthorized if token is missing or empty
  if token_empty(auth_token) then
    ngx.ctx.stop_phases = true
    return responses.send_HTTP_UNAUTHORIZED()
  end

  -- Actually call the Auth API to get session status and user data
  _, status, headers = check_token_validity(auth_token, config)

  -- Return 401 Unauthorized if token is not valid
  if status ~= 200 then
    ngx.ctx.stop_phases = true
    return responses.send_HTTP_UNAUTHORIZED()
  end

  -- Add all headers matching X-AUTH-DATA-* to request
  for name, value in pairs(headers) do
    if name:upper():match("X%-AUTH%-DATA%-") then
      ngx.req.set_header(name, value)
    end
  end
end

return _M
