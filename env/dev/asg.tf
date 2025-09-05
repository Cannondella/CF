module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "cf-asg"

  min_size                  = 2
  max_size                  = 6
  desired_capacity          = 2
  wait_for_capacity_timeout = "0"
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "ELB"

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
      max_healthy_percentage = 100
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "cf-asg"
  launch_template_description = "Web App"
  update_default_version      = true

  image_id          = "ami-00ca32bbc84273381"
  instance_type     = var.instance_type
  security_groups   = [aws_security_group.AppServer.id]
  enable_monitoring = false
  key_name          = "dev-ssh"
  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo yum -y install httpd
    sudo systemctl enable --now httpd
    echo "<h1>It works</h1>" > /var/www/html/index.html
  EOF
  )

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "cf-ssm-role-asg"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role example"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 8
        volume_type           = "gp3"
      }
    }
  ]

  # This will ensure imdsv2 is enabled, required, and a single hop which is aws security
  # best practices
  # See https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-4
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = { WhatAmI = "Volume" }
    }
  ]
}