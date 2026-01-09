variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}
variable "profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "SRE"
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}
