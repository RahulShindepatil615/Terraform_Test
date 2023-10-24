

data "aws_availability_zones" "available" {
  state = "available"
}

# create vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags       = local.common_tags
}
# create internet gateway
resource "aws_internet_gateway" "internet_gateway1" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.common_tags
}
# create subnet-1
resource "aws_subnet" "subnets" {
  count = var.public_subnet_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = local.common_tags
}

# create route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway1.id
  }
  tags = local.common_tags

}
# create route table association [associate route table to subnet-1]
resource "aws_route_table_association" "route-table-association" {
  count = var.public_subnet_count
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.route_table.id
}




