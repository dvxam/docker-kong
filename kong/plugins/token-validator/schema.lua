return {
  no_consumer = true, -- this plugin will only be API-wide,
  fields = {
    on = {type = "boolean", default = true},
  },
  self_check = function(schema, plugin_t, dao, is_updating)
    return true
  end
}
