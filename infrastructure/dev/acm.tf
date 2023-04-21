resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]

  tags = {
    Name        = "${local.prefix}-certificate"
    Environment = var.stage
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "this" {
  for_each = {
    for rec in aws_acm_certificate.this.domain_validation_options : rec.domain_name => {
      name   = rec.resource_record_name
      record = rec.resource_record_value
      type   = rec.resource_record_type
    }
  }

  zone_id = data.terraform_remote_state.hostedzone.outputs.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [
    each.value.record,
  ]

  allow_overwrite = true
}

# Validate the certificate
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}