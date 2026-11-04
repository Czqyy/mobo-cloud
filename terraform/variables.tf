variable "aws_region" {
  type        = string
  description = "AWS deployment region"
  default     = "eu-west-2"
}

variable "ami_id" {
  type        = string
  description = "AMI ID of pre-baked inference server instance"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance"
  default     = "t3.small"
}

variable "worker_ssh_key_name" {
  type        = string
  description = "Name of the EC2 key pair used to access worker instances"
}

variable "worker_ssh_allowed_cidr" {
  type        = string
  description = "IPv4 CIDR allowed to connect to worker instances over SSH"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of worker instances"
  default     = 1
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of worker instances"
  default     = 2
}
