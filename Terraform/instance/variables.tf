variable "public-subnet-1-id" { type = string }
variable "bastion-sg-id" { type = string }
variable "nat-sg-id" {type = string}

variable "private-subnet-1-id" { type = string }
variable "private-subnet-2-id" { type = string }

variable "web-sg-id" { type = string }
variable "was-sg-id" { type = string }

variable "public_alb_target_group_arn" { type = string }
variable "internal_alb_target_group_arn" {  type = string }
variable "ubuntu-ami-seoul" {
    type = string
    default = "ami-0a71e3eb8b23101ed"
}

variable "amazon-linux-2-ami-seoul" {
    type = string
    default = "ami-013c951bfeb5d9c3b"
}
