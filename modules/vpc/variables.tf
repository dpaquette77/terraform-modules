
variable "vpc_cidr" {
    type = string
    description = "the cidr block for the VPC"
}

variable "tags" {
    type = map(string)
    description = "tags to attach to the vpc"
}

variable "subnet_definitions" {
    type = map(map(string))
    description = "map of map that contains the AZ as the first key and private or public as the secondary key"
}

variable "create_nat_gatways" {
    type = bool
    description = "flag to control whether we create 1 NAT gateways for each private subnet"
    default = true
}

