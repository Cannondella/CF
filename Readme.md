# Modules Used
VPC, ALB, EC2, ASG

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