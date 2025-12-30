output "nat_instance_eni_id" {
    value = aws_instance.nat_server.primary_network_interface_id
}

output "web_asg_id" {
  value = aws_autoscaling_group.web_asg.id
}

output "was_asg_id" {
  value = aws_autoscaling_group.was_asg.id
}