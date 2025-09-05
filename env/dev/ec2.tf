module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "ssh-management"

  instance_type               = var.instance_type
  key_name                    = var.keypair
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  iam_role_name               = "cf-ssm-role-asg"
  create_security_group = false
  vpc_security_group_ids = [aws_security_group.ssh-server.id]

  tags = {
    Name = "ssh-management"
  }
}