terraform {
  backend "s3" {
    bucket         = "your-s3-bucket-name"       # Replace with your S3 bucket name
    key            = "terraform/state.tfstate"   # Path to store Terraform state
    region         = "us-east-1"                 # Modify to your AWS region
    dynamodb_table = "your-dynamodb-table-name"  # Replace with your DynamoDB table name
    encrypt        = true                        # Ensures state file encryption
  }
}
      