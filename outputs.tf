output "lb_id" {
  value = aws_lb.this.id
}

output "lb_arn" {
  value = aws_lb.this.arn
}

output "lb_arn_suffix" {
  value = aws_lb.this.arn_suffix
}

output "lb_dns_name" {
  value = aws_lb.this.dns_name
}

output "lb_zone_id" {
  value = aws_lb.this.zone_id
}
