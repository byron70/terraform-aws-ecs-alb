variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map
  default     = {}
}

variable "name_prefix" {
  description = "prefix for resources"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "lb_settings" {
  description = "map of settings for application load balancer, attributes are based on aws_lb attributes"
  type        = any
}

/*
variable "lb_settings2" {
  description = "map of settings for application load balancer, attributes are based on aws_lb attributes"
  type = object({
    internal                         = bool
    drop_invalid_header_fields       = bool
    idle_timeout                     = number
    enable_deletion_protection       = bool
    enable_cross_zone_load_balancing = bool
    ip_address_type                  = string
    subnets                          = list(string)
    security_groups                  = list(string)
  })
}
*/

variable "ports" {
  description = "The list of ports with access to the Load Balancer through HTTP listeners"
  type = list(object({
    port     = string
    cidr     = list(string)
    protocol = string
  }))
  default = [
    {
      port     = "80"
      cidr     = ["0.0.0.0/0"]
      protocol = "http"
    },
    {
      port     = "443"
      cidr     = ["0.0.0.0/0"]
      protocol = "https"
    }
  ]
}


variable "tg_settings" {
  description = "Settings for target group, attributes based on aws_lb_target_group"
  type        = any
}
/*
variable "tg_settings" {
  description = "Settings for target group, attributes based on aws_lb_target_group"
  type = object({
    deregistration_delay          = number
    slow_start                    = number
    load_balancing_algorithm_type = string
    stickiness = object({
      type            = string
      cookie_duration = number
      enabled         = bool
      }
    )
    health_check = list(
      object({
        enabled             = bool
        interval            = number
        path                = string
        timeout             = number
        healthy_threshold   = number
        unhealthy_threshold = number
        matcher             = string
    }))
  })
}
*/
