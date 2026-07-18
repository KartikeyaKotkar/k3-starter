variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for the k3s nodes"
  type        = string
  default     = "t3.small"
}

variable "node_count" {
  description = "Number of k3s nodes to provision"
  type        = number
  default     = 1
}

variable "ssh_key_name" {
  description = "Name of an existing AWS SSH key pair to use for the instances. If empty, a new key pair will be generated."
  type        = string
  default     = ""
}
