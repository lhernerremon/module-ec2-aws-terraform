resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tls_private_key_pem" {
  filename        = "ssh/${local.project}.pem"
  content         = tls_private_key.private_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "tls_public_key" {
  filename = "ssh/${local.project}.pub"
  content  = tls_private_key.private_key.public_key_openssh
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${local.project}-EC2-KEY"
  public_key = tls_private_key.private_key.public_key_openssh

  tags = {
    Name        = "${local.project}-EC2-KEY"
    project     = var.project_name
    environment = var.project_environment
  }
}
