locals {
  prefix       = "${var.name}-${var.stage}"
  region       = data.aws_region.current.name
  lab_role_arn = data.aws_iam_role.labrole.arn
  ecr_repo     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.prefix}-repo"
  log_group    = aws_cloudwatch_log_group.this.name
}