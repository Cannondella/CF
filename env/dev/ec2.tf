module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "ssh-management"

  instance_type = "t2.micro"
  key_name      = "dev-ssh"
  subnet_id     = module.vpc.private_subnets[0]

  tags = {
    Name   = "ssh-management"
  }
}