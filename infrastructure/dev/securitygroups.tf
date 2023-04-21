module "ecs_service_sg" {
  source     = "cloudposse/security-group/aws"
  version    = "2.0.0-rc1"
  attributes = ["ecs-primary"]

  allow_all_egress = true

  rule_matrix = [
    {
      source_security_group_ids = [module.ecs_alb_sg.id]
      self                      = null
      rules = [
        {
          key         = "OTHERS"
          type        = "ingress"
          from_port   = 31000
          to_port     = 61000
          protocol    = "tcp"
          description = "Allow non privileged ports"
        },
        {
          key         = "HTTPALB"
          type        = "ingress"
          from_port   = 5000
          to_port     = 5000
          protocol    = "tcp"
          description = "Allow HTTP from ALB"
        }
      ]
    }
  ]

  vpc_id = module.vpc.vpc_id
}

module "rds_sg" {
  source     = "cloudposse/security-group/aws"
  version    = "2.0.0-rc1"
  attributes = ["rds-sg"]

  allow_all_egress = true

  rule_matrix = [
    {
      source_security_group_ids = [module.ecs_service_sg.id]
      self                      = null
      rules = [
        {
          key         = "ECSINGRESS"
          type        = "ingress"
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          description = "Allow ingress to mysql DB"
        },
      ]
    }
  ]

  vpc_id = module.vpc.vpc_id
}

module "ecs_alb_sg" {
  source     = "cloudposse/security-group/aws"
  version    = "2.0.0-rc1"
  attributes = ["ecs-alb"]

  allow_all_egress = true

  rules = [
    {
      key         = "HTTP"
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow HTTP from everywhere"
    },
    {
      key         = "HTTPS"
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow HTTPS from everywhere"
    }
  ]

  vpc_id = module.vpc.vpc_id
}

module "vpce_sg" {
  source     = "cloudposse/security-group/aws"
  version    = "2.0.0-rc1"
  attributes = ["vpce-sg"]

  allow_all_egress = true

  rule_matrix = [
    {
      source_security_group_ids = [module.ecs_service_sg.id]
      self                      = null
      rules = [
        {
          key         = "HTTPS"
          type        = "ingress"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "Allow HTTPS from Task SG"
        }
      ]
    }
  ]

  vpc_id = module.vpc.vpc_id
}