
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = var.tags
}

resource "aws_subnet" "public_subnets" {
    for_each = var.public_subnets
    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value
    availability_zone = each.key
    tags = var.tags
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnets" {
    for_each = var.private_subnets
    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value
    availability_zone = each.key
    tags = var.tags
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = var.tags
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    tags = var.tags
}

resource "aws_route" "to_internet_route" {
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
} 

resource "aws_route_table_association" "public_route_associations" {
    for_each = aws_subnet.public_subnets
    subnet_id = each.value.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
    for_each = aws_subnet.private_subnets
    vpc_id = aws_vpc.vpc.id
    tags = var.tags
}

resource "aws_route" "private_subnet_to_internet_route" {
    for_each = toset(aws_nat_gateway.nat_gateways)
    route_table_id = aws_route_table.private_route_table[each.value.subnet_id]
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = each.value.id
} 

resource "aws_route_table_association" "private_route_associations" {
    for_each = aws_subnet.private_subnets
    subnet_id = each.value.id
    route_table_id = aws_route_table.private_route_table[each.value.availability_zone].id
}

resource "aws_network_acl" "public_nacl" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "public_nacl"
    }
    subnet_ids = [for sn in aws_subnet.public_subnets : sn.id]
}

resource "aws_network_acl_rule" "public_allow_all_in" {
    network_acl_id = aws_network_acl.public_nacl.id
    rule_number = 100
    egress = false
    protocol = "-1"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_allow_all_out" {
    network_acl_id = aws_network_acl.public_nacl.id
    rule_number = 100
    egress = true
    protocol = "-1"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl" "private_nacl" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "private_nacl"
    }
    subnet_ids = [for sn in aws_subnet.private_subnets : sn.id]
}

resource "aws_network_acl_rule" "private_allow_all_in" {
    network_acl_id = aws_network_acl.private_nacl.id
    rule_number = 100
    egress = false
    protocol = "-1"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_allow_all_out" {
    network_acl_id = aws_network_acl.private_nacl.id
    rule_number = 100
    egress = true
    protocol = "-1"
    rule_action = "allow"
    cidr_block = "0.0.0.0/0"
}

resource "aws_eip" "nat_gateway_eips" {
    count = var.create_nat_gateways ? length(aws_subnet.private_subnets) : 0
    vpc = true
    tags = var.tags
}

resource "aws_nat_gateway" "nat_gateways" {
    count = var.create_nat_gateways ? length(aws_subnet.private_subnets) : 0
    subnet_id = aws_subnet.private_subnets[count.index].id
    allocation_id = aws_eip.nat_gateway_eips[count.index].id
    tags = var.tags
}
