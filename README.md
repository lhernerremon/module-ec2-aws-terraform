# AWS EC2 Instance Terraform module

## Usage

```hcl
provider "aws" {
  region = "us-east-2"
  profile = "project"
}

...

module "ec2_instance" {
  source  = "github.com/lhernerremon/module-ec2-aws-terraform?ref=v0.0.1"
  
  project_name = "project"
  project_environment = "develop"
  ami_instance = "ami-0fb653ca2d3203ac1"
  monitoring_with_cloudwatch = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Project's name | `string` | `""` | yes |
| project_environment | Project environment | `string` | `""` | yes |
| ami_instance | ID of AMI to use for the instance | `string` | `""` | yes |
| monitoring_with_cloudwatch | Using cloudwatch alarms | `bool`  | `true` | no |
| instance_type | The type of instance to start | `string` | `"t2.micro"` | no |
| volume_size | Size of the volume in gibibytes (GiB) | `number` | `15` | no |
| sg_ports_in | Port list for ingress rules | `list(number)` | `[22, 80, 443]` | no |
| sg_ports_out | Port list for egress rules | `list(number)` | `[0]` | no |
| cloudwatch_period_check_minutes | Statistics review period in minutes | `number` | `15` | no |
| cloudwatch_threshold_cpu_utilization | CPU usage for alarm activation | `number` | `95` | no |
| cpu_utilization_evaluation_periods | Number of periods needed for alarm activation per cpu_utilization | `number` | `2` | no |
| status_check_failed_evaluation_periods | Number of periods needed for alarm activation per status_check_failed | `number` | `0.99` | no |

## Outputs
| Name | Description|
|------|:--------:|
| security_group_id | The ID of the security group |


## Resources that return

| Extension | Folder | Description |
|------|-------------|:--------:|
| .ip | ./ssh | Plain text file with the elastic IP address |
| .pem | ./ssh | Private key to access the server |
| .pub | ./ssh | Server public key |
