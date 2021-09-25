output "cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "id" {
  value = aws_vpc.this.id
}

output "igw" {
  value = aws_internet_gateway.igw.id
}