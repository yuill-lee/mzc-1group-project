output "nat_instance_eni_id" {
    value = aws_instance.nat_server.primary_network_interface_id
}

output "web_instance_ids" {
  value = [aws_instance.web_1.id, aws_instance.web_2.id]
}

output "was_instance_ids" {
  value = [aws_instance.was_1.id, aws_instance.was_2.id]
}