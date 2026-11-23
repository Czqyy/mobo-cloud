variable "aws_region" {
  type        = string
  description = "AWS deployment region"
  default     = "eu-west-2"
}

variable "ami_name" {
  type        = string
  description = "Name of AMI of pre-baked inference server instance"
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
  default     = 3
}

variable "instance_warmup" {
  type        = number
  description = "Estimated time(s) needed for new instance to warm up"
  default     = 60
}

variable "deregistration_delay" {
  type        = number
  description = "Draining interval(s) for requests to complete before deregistering target"
  default     = 30
}

variable "target_cpu" {
  type        = number
  description = "Target CPU utilisation rate"
  default     = 30
}
