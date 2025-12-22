output "nat-instance-eni-id" {
    value = aws_instance.nat-server.primary_network_interface_id
}