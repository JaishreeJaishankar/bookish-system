resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
  vpc_id              = module.vpc.vpc_id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${local.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecr.dkr"
  }
}

resource "aws_vpc_endpoint" "ecr-api-endpoint" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecr.api"
  }
}

resource "aws_vpc_endpoint" "ecs-agent" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecs-agent"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecs-agent"
  }
}

resource "aws_vpc_endpoint" "ecs-telemetry" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecs-telemetry"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecs-telemetry"
  }
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecs"
  }

}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.dynamic_subnets.private_route_table_ids
  policy            = data.aws_iam_policy_document.s3_ecr_access.json
  tags = {
    "Name" = "${local.prefix}-vpce-S3"
  }
}