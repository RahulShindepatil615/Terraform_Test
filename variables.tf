variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_subnet_count" {
  type = number
  default = 2
}
variable "instance_count" {
  type = number
  default = 2
}
variable "subnet_cidr" {
  type    = list(string)
  default = ["10.0.0.0/24","10.0.1.0/24"]
}
variable "subnet_1_cidr" {
  type    = string
  default = "10.0.0.0/24"
}
variable "subnet_2_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "ami_name" {
  type    = string
  default = "amzn2-ami-kernel-5.10-hvm-2.0.20230926.0-x86_64-gp2"
}
variable "project_name" {
  type    = string
  default = "test-webapp"
}
variable "billing_code" {
  type    = string
  default = "12345678"
}
variable "company_name" {
  type    = string
  default = "ABC-Company"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
