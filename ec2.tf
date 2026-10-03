resource "aws_instance" "main_instance" {
  ami                    = var.ami_instance
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_group.id]
  user_data              = file("${path.module}/user_data.sh")
  key_name               = aws_key_pair.key_pair.key_name

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
    encrypted   = true
    tags = {
      Name        = "${local.project}-EC2-VOLUME"
      project     = var.project_name
      environment = var.project_environment
    }
  }

  tags = {
    Name        = "${local.project}-EC2"
    project     = var.project_name
    environment = var.project_environment
  }
}
