return {
  no_consumer = true, -- this plugin will only be API-wide,
  fields = {
    on = {type = "boolean", default = true},
    header = {type = "string", default = "X-Auth-Token"}
  }
}
