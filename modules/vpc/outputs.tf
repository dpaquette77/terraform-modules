

output "vpc" {
    value = aws_vpc.vpc
}

output "private_subnets" {
    value = aws_subnet.private_subnets
}

output "public_subnets" {
    value = aws_subnet.public_subnets
}

output "private_route_table" {
    value = aws_route_table.private_route_table
}

output "public_route_table" {
    value = aws_route_table.public_route_table
}

output "private_nacl" {
    value = aws_network_acl.private_nacl
}

output "public_nacl" {
    value = aws_network_acl.public_nacl
}





