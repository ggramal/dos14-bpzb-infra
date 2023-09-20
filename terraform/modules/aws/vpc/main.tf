resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = var.nat_gws
  #  allocation_id = aws_eip.example.id
  subnet_id = aws_subnet.public[each.value.subnet_to_place_nat].id

  tags = {
    Name = each.value.name
  }

  depends_on = [aws_internet_gateway.gw, aws_subnet.public]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gw_name
  }
  depends_on = [aws_vpc.main]
}

resource "aws_subnet" "public" {
  for_each          = var.subnets_public
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.value.name
  }
  depends_on = [aws_vpc.main]
}

resource "aws_subnet" "private" {
  for_each          = var.subnets_private
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.value.name
  }
  depends_on = [aws_vpc.main, aws_subnet.public]
}
