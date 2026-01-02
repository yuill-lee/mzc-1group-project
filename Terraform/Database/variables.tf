variable "db_username" { type = string }
variable "db_password" { type = string }

variable "seoul_vpc_id" { type = string }
variable "seoul_private_subnets" { type = list(string) }
variable "seoul_db_sg_id" { type = string}

//variable "tokyo_vpc_id" { type = string }
variable "tokyo_private_subnets" { type = list(string) }
//variable "tokyo_db_sg_id" { type = string }
