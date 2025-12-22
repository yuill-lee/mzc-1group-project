# -------------------- Bastion Server -------------------- #
resource "aws_instance" "bastion-server" {
    instance_type = "t3.micro"
    ami = var.ubuntu-ami-seoul
    key_name = "Final-Project-Key"
    subnet_id = var.public-subnet-1-id
    vpc_security_group_ids = [var.bastion-sg-id]
    associate_public_ip_address = true

    tags = {
        Name = "Bastion-Server"
    }
}
# -------------------- Bastion Server -------------------- #
# -------------------- NAT Server -------------------- #
resource "aws_instance" "nat-server" {
    instance_type = "t3.micro"
    ami = var.amazon-linux-2-ami-seoul
    key_name = "Final-Project-Key"
    subnet_id = var.public-subnet-1-id
    vpc_security_group_ids = [var.nat-sg-id]
    source_dest_check = false

    tags = {
        Name = "NAT-Server"
    }
}
# -------------------- NAT Server -------------------- #
# -------------------- WEB ALB / Target Group -------------------- #



# -------------------- WEB ALB / Target Group -------------------- #
# -------------------- WAS ALB / Target Group -------------------- #



# -------------------- WAS ALB / Target Group -------------------- #
