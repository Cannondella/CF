# Modules Used
VPC, ALB, EC2, ASG

# General 
added default tags to providers.tf for terraform=true and environment=dev and removed from each individual doc

# Subnets/High AZ Stuff
3 subnet tiers across 2 AZs, A and B.
6 Total subnets
1 NatGW per private AZ. so 2 total

# Subnet-naming
The local names in the terraform doc still show private, public, db but in AWS names are correct
10.1.0.0/16 - vpc 
10.1.1.0/24 - AppA 
10.1.2.0/24 - AppB 

10.1.3.0/24 - MgtA 
10.1.4.0/24 - MgtB 

10.1.5.0/24 - BackA 
10.1.6.0/24 - BackB

# ASG/AppServers
Deleted initial lifecycle hooks block
changed "enable_monitoring = false", dont need detailed monitoring, cost
Deleted extra EBS volume, set EBS type to gp3 and 8gb
Used latest AL2023 AMI ID, hardcoded for now
Added user data for install httpd and systemctl enable --now httpd and a echo to index.html for basic page
The EC2s allow traffic from the alb security group ID on ports 80 and 443

# ALB
Removed HTTPs listener, no ACM cert/domain/dns
Removed listener and target group from ALB config, created manually outside of module config

# To do
set launch template to use data block to lookup latest AL2023 AMI ID
add EBS volumes for ASG to have name of the ec2, attachedTo tag and nametag
Attach a regional WAF to the ALB with some basic AWS managed rules
Register a domain and assign an ACM Cert to the ALB and a DNS entry for the cname to point to the ALB hostname
I created the SSH keypairs manually inside of AWS and referenced them in the docs
