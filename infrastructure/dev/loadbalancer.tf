resource "aws_lb" "this" {
  name               = "${var.name}-alb-${var.stage}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.ecs_alb_sg.id]
  subnets            = module.dynamic_subnets.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}-alb-${var.stage}"
    Environment = var.stage
  }
}

resource "aws_alb_target_group" "this" {
  name        = "${var.name}-tg-${var.stage}"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.name}-tg-${var.stage}"
    Environment = var.stage
  }

  depends_on = [aws_lb.this]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = data.terraform_remote_state.hostedzone.outputs.zone_id
  name    = "${var.stage}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}