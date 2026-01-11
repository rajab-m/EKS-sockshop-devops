variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "project_name" {
  type    = string
  default = "sock-shop"
}

variable "key_name" {
  type = string
  default = "sock-shop_keypair"
}

variable "allowed_ip" {
  type = string
  default = "0.0.0.0/0"
}

variable "cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "cidr_eks" {
  type = string
  default = "0.0.0.0/0"
}

variable "letsencrypt_email" {
  type    = string
  default = "rajab_30@hotmail.com"
}