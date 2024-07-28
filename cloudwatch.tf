resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  count = var.monitoring_with_cloudwatch ? 1 : 0

  alarm_name          = "${local.project}-RebootInstanceCPUAbove-${var.cloudwatch_threshold_cpu_utilization}-PercentageForMore-${var.cloudwatch_period_check_minutes}Min"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"

  evaluation_periods = var.cpu_utilization_evaluation_periods
  period             = var.cloudwatch_period_check_minutes * 60
  threshold          = var.cloudwatch_threshold_cpu_utilization

  alarm_description = "Reboot instance if CPU usage is more than ${var.cloudwatch_threshold_cpu_utilization}% for more than ${var.cloudwatch_period_check_minutes} minutes."

  dimensions = {
    InstanceId = aws_instance.main_instance.id
  }

  alarm_actions = [
    "arn:aws:automate:${data.aws_region.current.name}:ec2:reboot"
  ]

  tags = {
    Name        = "${local.project}-CPUUtilization-CloudWatch",
    project     = var.project_name
    environment = var.project_environment
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  count = var.monitoring_with_cloudwatch ? 1 : 0

  alarm_name          = "${local.project}-RebootInstanceStatusCheckFailedForMore-${var.cloudwatch_period_check_minutes}Min"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed"
  statistic           = "Average"

  evaluation_periods = var.status_check_failed_evaluation_periods
  period             = var.cloudwatch_period_check_minutes * 60
  threshold          = "1"

  alarm_description = "Restart the instance if the health check failed for more than ${var.cloudwatch_period_check_minutes} minutes."

  dimensions = {
    InstanceId = aws_instance.main_instance.id
  }

  alarm_actions = [
    "arn:aws:automate:${data.aws_region.current.name}:ec2:reboot"
  ]

  tags = {
    Name        = "${local.project}-StatusCheckFailed-CloudWatch"
    project     = var.project_name
    environment = var.project_environment
  }
}
