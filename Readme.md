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

# ASG
Deleted initial lifecycle hooks block
changed "enable_monitoring = false", dont need detailed monitoring, cost
Deleted extra EBS volume, set EBS type to gp3 and 8gb
Used latest AL2023 AMI ID, hardcoded for now
Added user data for install httpd and systemctl enable --now httpd

# ALB
Removed HTTPs listener, no ACM cert/domain/dns

# To do
set launch template to use data block to lookup latest AL2023 AMI ID
