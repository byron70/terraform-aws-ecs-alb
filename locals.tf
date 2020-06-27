locals {
  common_tags = merge(
    var.common_tags,
    {
      "Name" : var.name_prefix
    }
  )
  stickiness = {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }
}
