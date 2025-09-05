# What security gaps exist?
SSH key is available for the servers, SSM can be more secure  
No WAFs attached to ALB  

# What availability issues?
The SSH/Bastion server is only in one AZ, could deploy two  
The ASG has availability if one zone goes down, but may reduce overall hosts

# Cost optimization opportunities?
Could set automated scaling to go up/down over weekend or based on most appropriate schedule  

# Operational shortcomings
No WAFs  
No VPC Flow Logs
Retention policies for cloudwatch log groups  
No customized cloudwatch agent logs for in OS logging, /var/logs
No domain/identity management
No registrar domain name/DNS/ACM Cert for the ALB

# Improvement Plan
Organized by Priority
Attach a regional WAF to the ALB with some basic AWS managed rules  
Register a domain and assign an ACM Cert to the ALB and a DNS entry for the cname to point to the ALB hostname  
Add a second bastion server in a second AZ 
set launch template to use data block to lookup latest AL2023 AMI ID  
add EBS volumes for ASG to have name of the ec2, attachedTo tag and nametag  
I created the SSH keypairs manually inside of AWS and referenced them in the docs, but could generate key material for the keypair locally and create using that key material in the future. Did not want to expose any keypairs in the config/git repo.  
The SSH Management EC2 uses a randomly assigned public IP that is lost on stop/start. Assign a static EIP so the IP is not lost  
ALB always gets stuck deleting on terraform destroy because deletion protection, disable it in tf doc, maybe leave enabled for prod env
Fixing alot of the naming/tagging

# Steps for Terraform deployment  
cd /env/dev  
aws configure sso (use profile name dev)  
terraform init  
terraform apply  
  
# Steps to SSH to bastion server and appservers
SSH to bastion host  
Putty using private key, dev-ssh.ppk (windows), dev-ssh.pem (linux)  
User is ec2-user  
  
SSH to AppServer instances from bastion host:   
copy dev-ssh.pem to dir below  
chmod 400 ~/.ssh/dev-ssh.pem  
ssh -i ~/.ssh/dev-ssh.pem ec2-user@<privateIP>  


# Modules Used  
Terraform's AWS module for VPC, ALB, EC2, ASG  
  
# General   
added default tags to providers.tf for terraform=true and environment=dev and removed from each individual doc  
SSM Roles/SSM work across the EC2s for extra level of access in case SSH fails  
  
# Security Groups  
cf-alb - opens 80/443 from internet  
App-Server-SG - opens 80/443 from the ALB's SG and 22 from the SSH Server's SG  
SSH-Server-SG - opens 22 from /32 public IP

# Subnets/High Availability Stuff  
3 subnet tiers across 2 AZs, A and B.  
6 Total subnets  
1 NatGW per private AZ. so 2 total  
  
# Subnet-naming  
10.1.0.0/16 - vpc   
  
10.1.1.0/24 - AppA    
10.1.2.0/24 - AppB   
10.1.3.0/24 - MgtA   
10.1.4.0/24 - MgtB   
10.1.5.0/24 - BackA   
10.1.6.0/24 - BackB  
  
# ASG/AppServers  
Deleted initial lifecycle hooks block, not used or needed  
changed "enable_monitoring = false", dont need detailed monitoring, cost  
Deleted extra EBS volume, set EBS type to gp3 and 8gb  
Used latest AL2023 AMI ID, hardcoded for now  
Added user data for install httpd and systemctl enable --now httpd and a echo to index.html for basic page  
The EC2s allow traffic from source of alb security group ID on ports 80 and 443  
  
# ALB  
Removed HTTPs listener, no ACM cert/domain/dns  
Removed listener and target group from ALB config, created manually outside of the ALB Module  
Associated target group to ASG via the tg.tf config file  
