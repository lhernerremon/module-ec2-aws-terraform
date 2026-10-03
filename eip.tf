resource "aws_eip" "api_instance_ip" {
  instance = aws_instance.main_instance.id
  tags = {
    Name        = "${local.project}-EC2-EIP"
    project     = var.project_name
    environment = var.project_environment
  }
}

resource "local_file" "instance_ip_local_file" {
  filename = "ssh/${local.project}.ip"
  content  = aws_eip.api_instance_ip.public_ip
}
