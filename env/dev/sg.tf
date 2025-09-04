# AppServer Security Group
resource "aws_security_group" "AppServer" {
  name        = "AppServer"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id            = aws_security_group.AppServer.id
  referenced_security_group_id = module.alb.security_group_id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id            = aws_security_group.AppServer.id
  referenced_security_group_id = module.alb.security_group_id
  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id            = aws_security_group.AppServer.id
  referenced_security_group_id = aws_security_group.SSHServer.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.AppServer.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# SSH Server SG
resource "aws_security_group" "SSHServer" {
  name        = "AppServer"
  description = "Allows SSH From Specific IPs"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id            = aws_security_group.SSHServer.id
  cidr_ipv4 = "108.224.102.67/32"
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
