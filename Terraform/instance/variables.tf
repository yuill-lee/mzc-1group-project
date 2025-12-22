variable "public-subnet-1-id" { type = string }
variable "bastion-sg-id" { type = string }
variable "nat-sg-id" {type = string}
/*
variable "public-subnet-2" { type = string }
variable "private-subnet-1" { type = string }
variable "private-subnet-2" { type = string }

variable "web-sg" { type = string }
variable "was-sg" { type = string }
variable "db-sg" { type = string }

variable "alb-sg" { type = string }
*/

variable "ubuntu-ami-seoul" {
    type = string
    default = "ami-0a71e3eb8b23101ed"
}

variable "amazon-linux-2-ami-seoul" {
    type = string
    default = "ami-013c951bfeb5d9c3b"
}