resource "aws_lb" "this" {
  name                             = format("%s-lb", var.name_prefix)
  internal                         = lookup(var.lb_settings, "internal", false)
  load_balancer_type               = "application"
  drop_invalid_header_fields       = lookup(var.lb_settings, "drop_invalid_header_fields", false)
  subnets                          = lookup(var.lb_settings, "subnets", [])
  idle_timeout                     = lookup(var.lb_settings, "idle_timeout", 60)
  enable_deletion_protection       = lookup(var.lb_settings, "enable_deletion_protection", false)
  enable_cross_zone_load_balancing = lookup(var.lb_settings, "enable_cross_zone_load_balancing", false)
  ip_address_type                  = lookup(var.lb_settings, "ip_address_type", "ipv4")
  security_groups = compact(
    concat(
      lookup(var.lb_settings, "security_groups", []),
    [aws_security_group.this.id]),
  )
  tags = merge({ Name = format("%s-lb", var.name_prefix) }, var.common_tags)
}

resource "aws_lb_target_group" "lb_http_tgs" {
  count                         = length(var.ports) > 0 ? length(var.ports) : 0
  name                          = "${var.name_prefix}-lb-tg-${count.index}"
  port                          = tonumber(split("-", var.ports[count.index].port)[0])
  protocol                      = upper(var.ports[count.index].protocol)
  vpc_id                        = var.vpc_id
  deregistration_delay          = lookup(var.tg_settings, "deregistration_delay", 300)
  slow_start                    = lookup(var.tg_settings, "slow_start", 0)
  load_balancing_algorithm_type = lookup(var.tg_settings, "load_balancing_algorithm_type", "round_robin")
  dynamic "stickiness" {
    for_each = lookup(var.tg_settings, "stickiness", [local.stickiness])
    content {
      type            = stickiness.value.type
      cookie_duration = stickiness.value.cookie_duration
      enabled         = stickiness.value.enabled
    }
  }
  dynamic "health_check" {
    for_each = lookup(var.tg_settings, "health_check", [{}])
    content {
      enabled             = lookup(health_check.value, "enabled", true)
      interval            = lookup(health_check.value, "interval", 30)
      path                = lookup(health_check.value, "path", "/")
      protocol            = upper(var.ports[count.index].protocol)
      timeout             = lookup(health_check.value, "timeout", 5)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", 3)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", 3)
      matcher             = lookup(health_check.value, "matcher", "200")
    }
  }
  target_type = "ip"
  tags = merge({
    Name = "${var.name_prefix}-lb-tg-${count.index}"
  }, local.common_tags)
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_lb.this]
}
