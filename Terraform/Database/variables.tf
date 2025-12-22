# Database/variables.tf

variable "subnet_ids" {
  description = "RDS가 위치할 서브넷 ID 리스트"
  type        = list(string)
}

variable "db_sg_id" {
  description = "RDS 보안 그룹 ID"
  type        = string
}