
variable "ami" {
    type = string
    description = "ami id to use for the asg's instances"
}

variable "instance_type" {
    type = string
    description = "instance type to use for the asg's instances"
}

variable "user_data" {
    type = string
    description = "user_data to use for the asg's instances"
}

variable "min_size" {
    type = number
    description = "min size to use for the asg"
}

variable "max_size" {
    type = number
    description = "max size to use for the asg"
}

variable "desired_capacity" {
    type = number
    description = "desired capacity for the asg"
}

variable "subnet_ids" {
    type = list(string)
    description = "list of subnet ids to spread instances on"
}

variable "port" {
    type = number
    description = "port to allow for instances"
}

variable "vpc_id" {
    type = string
    description = "vpc id in which to create the resources in"
}

