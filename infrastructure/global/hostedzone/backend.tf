terraform {
  backend "s3" {
    bucket = "bookish-ninja-dev-state"
    key    = "hostedzone/terraform.tfstate"
    region = "us-east-1"
  }
}
