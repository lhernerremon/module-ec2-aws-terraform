resource "aws_security_group" "security_group" {
  name   = "${local.project}-EC2-SG"
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.project}-EC2-SG"
    project     = var.project_name
    environment = var.project_environment
  }
}
