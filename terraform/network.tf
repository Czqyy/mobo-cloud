data "aws_vpc" "custom" {
  id = var.vpc_id
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.custom.id]
  }
}

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "inference-alb-sg"
  description = "Public ingress for ALB"
  vpc_id      = data.aws_vpc.custom.id
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_public" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow inbound HTTP from public internet"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_workers" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.worker_sg.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  description                  = "Forward traffic to workers on port 8000"
}

# Worker Security Group
resource "aws_security_group" "worker_sg" {
  name        = "inference-worker-sg"
  description = "Worker accepting traffic from ALB"
  vpc_id      = data.aws_vpc.custom.id
}

resource "aws_vpc_security_group_ingress_rule" "worker_from_alb" {
  security_group_id            = aws_security_group.worker_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  description                  = "Allow port 8000 exclusively from ALB SG"
}

resource "aws_vpc_security_group_ingress_rule" "worker_ssh" {
  security_group_id = aws_security_group.worker_sg.id
  cidr_ipv4         = var.worker_ssh_allowed_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH access to workers"
}

resource "aws_vpc_security_group_egress_rule" "worker_allow_all_outbound" {
  security_group_id = aws_security_group.worker_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}
