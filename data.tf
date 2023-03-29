data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_region" "current" {}
