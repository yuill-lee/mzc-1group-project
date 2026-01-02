variable "vpc_cidr" { type = string }
variable "public_subnet_1_cidr" { type = string }
variable "public_subnet_2_cidr" { type = string }
variable "private_subnet_1_cidr" { type = string }
variable "private_subnet_2_cidr" { type = string }

variable "key_pair" { type = string }
variable "ubuntu_ami" { type = string }
variable "amazon_linux_2_ami" { type = string }
variable "rds_endpoint" { type = string }