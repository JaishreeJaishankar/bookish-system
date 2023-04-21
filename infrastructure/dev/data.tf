data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_role" "labrole" {
  name = "ecsTaskExecutionRole"
}

data "terraform_remote_state" "hostedzone" {
  backend = "s3"
  config = {
    bucket = "${local.prefix}-state"
    key    = "hostedzone/terraform.tfstate"
    region = local.region
  }
}

data "aws_iam_policy_document" "s3_ecr_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::prod-${local.region}-starport-layer-bucket/*",
    ]
  }
}