
variable "vpc_cidr" {
    type = string
    description = "the cidr block for the VPC"
}

variable "tags" {
    type = map(string)
    description = "tags to attach to the vpc"
}

variable "private_subnets" {
    type = map(string)
    description = "map of AZ to private subnet cidr"
}

variable "public_subnets" {
    type = map(string)
    description = "map of AZ to public subnet cidr"
}

variable "create_nat_gateways" {
    type = bool
    description = "flag to control whether we create 1 NAT gateways for each private subnet"
    default = true
}

