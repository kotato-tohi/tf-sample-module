resource "aws_subnet" "pub" {
  count      = var.pub_sbn_cnt
  vpc_id     = var.vpc_id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
  # availability_zone       = var.az
  availability_zone       = var.az_list[count.index % 3]
  map_public_ip_on_launch = var.pub_ip
  tags = {
    "Name" = var.tag_name
    "Cost" = var.tag_cost
  }
}

resource "aws_subnet" "pvt" {
  count                   = var.pvt_sbn_cnt
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + length(aws_subnet.pub))
  availability_zone       = var.az
  map_public_ip_on_launch = var.pub_ip
  tags = {
    "Name" = var.tag_name
    "Cost" = var.tag_cost
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = var.vpc_id
  tags = {
    "Name" = var.tag_name
    "Cost" = var.tag_cost
  }
}

resource "aws_route" "dgw" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.rtb.id
  gateway_id             = var.igw
}

resource "aws_route_table_association" "public" {
  count          = var.pub_sbn_cnt
  subnet_id      = aws_subnet.pub[count.index].id
  route_table_id = aws_route_table.rtb.id
}
