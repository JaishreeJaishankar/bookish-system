terraform {
  backend "s3" {
    bucket         = "bookish-ninja-dev-state"
    key            = "bookish-ninja-infrastructure/terraform.tfstate"
    dynamodb_table = "bookish-ninja-dev-locks"
    region         = "us-east-1"
    encrypt        = true
  }
}
