output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnets" {
  value = aws_subnet.private_subnets[*].id
}

output "vpc_cidr_block" {
  value = aws_vpc.main_vpc.cidr_block
}
