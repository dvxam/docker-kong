return {
  no_consumer = true, -- this plugin will only be API-wide,
  fields = {
    on = {type = "boolean", default = true},
    header = {type = "string", default = "X-Auth-Token"},
    auth_service = {type = "string", default = "auth"},
    auth_service_url = {type = "string", default = ""}
  }
}
