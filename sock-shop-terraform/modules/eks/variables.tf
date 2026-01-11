variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "bastion_sg" {
  type = string
}

variable "key_name" {}


