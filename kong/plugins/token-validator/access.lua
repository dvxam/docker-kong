local responses = require "kong.tools.responses"
local http_client = require "kong.tools.http_client"

local _M = {}

local function extract_auth_token(config)
  -- Extract auth token from request headers
  return ngx.req.get_headers()[config.header]
end

local function token_empty(token)
  return token == nil or #token <= 0
end

local function find_authentication_url(config)
  -- If config.auth_service_url is set, this is the choosen value
  if config.auth_service_url and #config.auth_service_url > 0 then
    return config.auth_service_url
  end

  -- Else it bases url on config.auth_service.upstream_url and path /session
  local apis, err = dao.apis:find_by_keys { name = config.auth_service }
  if #apis == 1 then
    return apis[1].upstream_url .. 'session'
  end

  -- If neither auth_service_url or auth_service is set, it returns
  return "http://0.0.0.0/session"
end

local function check_token_validity(auth_token, config)
  local url = find_authentication_url(config)
  return http_client.get(url, {}, { [config.header] = auth_token })
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
