resource "aws_route53_zone" "this" {
  name          = var.domain_name
  force_destroy = true

  tags = {
    Environment = var.stage,
    App         = var.namespace,
    Name        = "${var.name}-${var.stage}-zone"
  }
}