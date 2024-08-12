#############################
### VIRTUAL PRIVATE CLOUD ###
#############################

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

###############
### SUBNETS ###
###############

resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = element(data.aws_availability_zones.availability_zones.names, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.${count.index + 4}.0/24"
  availability_zone       = element(data.aws_availability_zones.availability_zones.names, count.index)
  map_public_ip_on_launch = false
}

########################
### INTERNET GATEWAY ###
########################

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}

####################
### ROUTE TABLES ###
####################

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = 1
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# resource "aws_eip" "nat_eip" {}

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet[0].id
# }
