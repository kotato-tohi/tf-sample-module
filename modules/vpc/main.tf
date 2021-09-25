resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns

  tags = {
    "Name" = var.tag_name
    "Cost" = var.tag_cost
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = var.tag_name
    "Cost" = var.tag_cost
  }
}


