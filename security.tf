
resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-lb-sg"
  description = "Controls access to the Load Balancer"
  vpc_id      = var.vpc_id
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = format("%s-lb-sg", var.name_prefix) }, var.common_tags)
}

resource "aws_security_group_rule" "this" {
  count             = length(var.ports) > 0 ? length(var.ports) : 0
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  from_port         = tonumber(split("-", var.ports[count.index].port)[0])
  to_port           = tonumber(reverse(split("-", var.ports[count.index].port))[0])
  protocol          = "tcp"
  cidr_blocks       = var.ports[count.index].cidr
}
