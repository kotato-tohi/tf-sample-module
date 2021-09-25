#-------------------------------------------#
# Application Load Balancer Security Group
#-------------------------------------------#

resource "aws_security_group" "alb_sg" {

  name        = "alb_sg"
  description = "Allow inbound traffic alb"
  vpc_id      = var.vpc_id

  egress = [
    {
      description      = "outbound allow rule"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}



resource "aws_security_group_rule" "alb_ssh" {
  description       = "Allow http traffic from internet"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_https" {
  description       = "Allow ssh traffic from internet"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

#-------------------------------------------#
# EC2 Security Group
#-------------------------------------------#

resource "aws_security_group" "ec2_sg" {

  name        = "ec2_sg"
  description = "Allow inbound traffic ec2"
  vpc_id      = var.vpc_id

  egress = [
    {
      description      = "outbound allow rule"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}

resource "aws_security_group_rule" "ec2_ssh" {
  description = "Allow ssh traffic from internet"
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ec2_http" {
  description = "Allow ssh traffic from internet"
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  # cidr_blocks       = ["0.0.0.0/0"]
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ec2_sg.id
}

#-------------------------------------------#
# RDS Security Group
#-------------------------------------------#
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow inbound traffic rds"
  vpc_id      = var.vpc_id
  egress = [
    {
      description      = "test"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  tags = {
    Name = var.tag_name
    Cost = var.tag_cost
  }
}

resource "aws_security_group_rule" "rds_mysql" {
  description              = "Allow mysql traffic from ec2_sg"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_sg.id
  security_group_id        = aws_security_group.rds_sg.id
}
