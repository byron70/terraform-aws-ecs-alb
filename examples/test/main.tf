provider "aws" {
  region = "us-east-2"
}

module "ecs-lb" {
  source = "../../"

  # see this for additional settings: https://www.terraform.io/docs/providers/aws/r/lb.html
  lb_settings = {
    subnets      = ["subnet-1dbf8457", "subnet-4adb3e31"]
    idle_timeout = 30
    # merged with security groups created with port definitions
    security_groups = ["sg-07cbbd37430eddbc8"]
  }

  name_prefix = "testing"

  # for security groups and target groups
  ports = [
    {
      port     = "8080"
      cidr     = ["0.0.0.0/0"]
      protocol = "http"
    },
    {
      port     = "8081-8089"
      cidr     = ["0.0.0.0/0"]
      protocol = "http"
    },
    {
      port     = "8443"
      cidr     = ["0.0.0.0/0"]
      protocol = "https"
    }
  ]

  # see this for additional settings: https://www.terraform.io/docs/providers/aws/r/lb_target_group.html
  tg_settings = {
    health_check = [
      {
        interval = 60
        path     = "/index.html"
      }
    ]
    stickiness = [
      {
        type            = "lb_cookie"
        cookie_duration = 86399
        enabled         = true
      }
    ]
  }

  vpc_id = "vpc-f9689090"

  common_tags = {
    Environment = "test"
    Expire      = "now"
  }
}
