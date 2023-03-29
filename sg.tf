resource "aws_security_group" "security_group" {
  name   = "${var.project_name}-${var.project_environment}-SG"
  vpc_id = data.aws_vpc.default_vpc.id

  dynamic "ingress" {
    for_each = toset(var.sg_ports_in)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = toset(var.sg_ports_out)
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
