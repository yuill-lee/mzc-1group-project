output "nat-instance-eni-id" {
    value = aws_instance.nat-server.primary_network_interface_id
}

output "web_instance_ids" {
  value = [aws_instance.web-1.id, aws_instance.web-2.id]
}

output "was_instance_ids" {
  value = [aws_instance.was-1.id, aws_instance.was-2.id]
}