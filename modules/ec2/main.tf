resource "aws_instance" "ec2" {
  count                       = var.ec2_instance
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  vpc_security_group_ids      = [var.ec2_sgs.id]
  subnet_id                   = var.ec2_subnet[count.index].id
  key_name                    = var.ec2_key
  associate_public_ip_address = var.ec2_pub_ip

  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}