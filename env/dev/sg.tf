resource "aws_security_group" "app" {
  name        = "cf-app-sg"
  description = "app server launch template sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "VPC-local"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
