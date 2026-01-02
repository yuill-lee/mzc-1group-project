variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "ubuntu_ami_seoul" {
    type = string
    default = "ami-0a71e3eb8b23101ed"
}

variable "ubuntu_ami_tokyo" {
    type = string
    default = "ami-0aec5ae807cea9ce0"
}

variable "amazon_linux_2_ami_seoul" {
    type = string
    default = "ami-013c951bfeb5d9c3b"
}

variable "amazon_linux_2_ami_tokyo" {
    type = string
    default = "ami-0536b5f8533c594b5"
}