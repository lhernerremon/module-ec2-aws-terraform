# AWS EC2 Instance Terraform module

This Terraform module will create an EC2 instance with an Elastic IP, an SSH key pair and CloudWatch alarms that reboot it. It will also create its security group, which the RDS module uses to allow access to the database.

It will install docker and fail2ban within the instance post-creation. The script uses `apt`, the Docker repository for Ubuntu and `/home/ubuntu`, so `ami_instance` must be an Ubuntu x86_64 AMI (no arm64). It also adds shell aliases for Docker Compose and Django projects.

## Usage

```hcl
provider "aws" {
  region = "us-east-2"
  profile = "project"
}

module "ec2_instance" {
  source  = "github.com/lhernerremon/module-ec2-aws-terraform?ref=v2.0.0"

  project_name = "project"
  project_environment = "develop"
  ami_instance = "ami-loremipsum"
  instance_type = "t3a.small"
  volume_size = 20
}
```

## Inputs

| Name                                   | Description                                                           | Type           | Default         | Required |
| -------------------------------------- | --------------------------------------------------------------------- | -------------- | --------------- | :------: |
| project_name                           | Project's name                                                        | `string`       |                 |   yes    |
| project_environment                    | Project environment                                                   | `string`       | `"development"` |    no    |
| ami_instance                           | ID of the Ubuntu x86_64 AMI to use for the instance                   | `string`       |                 |   yes    |
| instance_type                          | The type of instance to start (x86_64)                                | `string`       | `"t3a.small"`   |    no    |
| volume_size                            | Size of the encrypted `gp3` root volume in gibibytes (GiB)            | `number`       | `20`            |    no    |
| sg_ports_in                            | Port list for ingress rules. Egress allows all traffic                | `list(number)` | `[22, 80, 443]` |    no    |
| monitoring_with_cloudwatch             | Using cloudwatch alarms                                               | `bool`         | `true`          |    no    |
| cloudwatch_period_check_minutes        | Statistics review period in minutes                                   | `number`       | `15`            |    no    |
| cloudwatch_threshold_cpu_utilization   | CPU usage for alarm activation                                        | `number`       | `95`            |    no    |
| cpu_utilization_evaluation_periods     | Number of periods needed for alarm activation per cpu_utilization     | `number`       | `2`             |    no    |
| status_check_failed_evaluation_periods | Number of periods needed for alarm activation per status_check_failed | `number`       | `1`             |    no    |

## Outputs

| Name              | Description                        |
| ----------------- | ---------------------------------- |
| instance_id       | ID of the EC2 instance             |
| public_ip         | Elastic IP address of the instance |
| security_group_id | The ID of the security group       |

## Resources that return

| Extension | Folder |                 Description                 |
| --------- | ------ | :-----------------------------------------: |
| .ip       | ./ssh  | Plain text file with the elastic IP address |
| .pem      | ./ssh  |  Private key to access the server (`0600`)  |
| .pub      | ./ssh  |              Server public key              |

**Note:** the `.pem` file and the `terraform.tfstate` hold the private key in plain text. Keep both out of version control.
