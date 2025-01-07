variable "region" {
  default = "us-east-1"

}
variable "cidr_block" {
  default     = ""
  description = "Main Cidr Block"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["172.16.1.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["172.16.2.0/24"]
}
variable "suffix" {
  type = string

}
