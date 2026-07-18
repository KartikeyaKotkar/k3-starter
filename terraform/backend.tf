terraform {
  # We are using a local backend for this starter project to simplify initial setup.
  # Configuring an S3 backend + DynamoDB lock requires existing AWS resources (the bucket and table),
  # which introduces a chicken-and-egg problem for a starter repository.
  # For a production setup, replace this with:
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "k3-starter/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
  backend "local" {
    path = "terraform.tfstate"
  }
}
