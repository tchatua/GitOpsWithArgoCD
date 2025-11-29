#!/bin/bash

# Initialize Terraform:
terraform init

# See the plan:
terraform plan 

# Apply:
terraform apply 

# After apply completes, you’ll see outputs including the public_ip. SSH into the instance:
# ssh -i ~/.ssh/id_rsa ubuntu@<public_ip>

