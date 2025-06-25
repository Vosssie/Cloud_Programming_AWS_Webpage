variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1" # Required for certificates
}

variable "domain" {
  description = "Domain name for the website"
  type        = string
  default     = "4seeable.co.za"
}

variable "bucket" {
  description = "Name of the S3 bucket for website hosting"
  type        = string
  default     = "4seeable-bucket"
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges for S3 access"
  type        = list(string)
  default     = [ ]
}

variable "vpc_id" {
  description = "VPC ID for autoscaling group"
  type        = string
  default = "vpc-0eac01772381095ae"
}

variable "subnet_ids" {
  description = "List of subnet IDs for autoscaling group"
  type        = list(string)
  default = [
    "subnet-050f01599d33a2d5b",
    "subnet-00c063abf9cd9a602"

  ] ## At least 2 for high availability
}

variable "ami_id" {
  description = "AMI ID for web servers"
  type        = string
  default = "ami-09e6f87a47903347c" ## Default Windows Server 2022 us-east-1
}

variable "instance_type_scale" {
  description = "Instance type for web servers"
  default     = "t3.micro"
}

variable "key_name_scale" {
  description = "SSH key name for EC2 instances"
  type        = string
  default = "website-server-key"
}

variable "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool for authentication"
  type        = string
  default = "Student"
}

variable "cognito_client_id" {
  description = "The Client ID of the Cognito User Pool Client"
  type        = string
  default = "Teacher"
}