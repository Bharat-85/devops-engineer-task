output "launch_configuration_name" {
  value = aws_launch_configuration.web_launchconfig.name
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.web_asg.name
}