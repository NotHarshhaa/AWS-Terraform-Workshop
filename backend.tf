# Backend configuration for remote state storage
# NOTE: You must initialize this backend with proper values before applying
# Real information for remote state store in backend.hcl
terraform {
  backend "s3" {}
}

# key : The key is the path within the S3 bucket where the Terraform state file will be stored. 
#       It is defined in the backend.hcl file as "aws-terraform-workshop/terraform.tfstate".

# region : The region specifies the AWS region where the S3 bucket is located.
#          It is defined in the backend.hcl file as "us-east-1".

# dynamodb_table : The DynamoDB table is used for state locking to prevent concurrent modifications. 
#                  It is defined in the backend.hcl file as "terraform-lock".

# encrypt : The encrypt option is set to true, which means that the state file will be encrypted at rest in the S3 bucket.
#           This is defined in the backend.hcl file as "true".

# use_lockfile : The use_lockfile option is set to true, which means that Terraform will 
#                create a local lock file to prevent concurrent operations on the same state file.