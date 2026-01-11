variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "cidr" {
  type        = string
  description = "VPC CIDR block"
}
variable "cluster_name" {
  type = string
}
