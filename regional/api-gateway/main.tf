provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

############### Create API Gateway ###############

resource "aws_apigatewayv2_api" "this" {
  name          = var.api_gw_name
  protocol_type = "HTTP"
  cors_configuration {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }
  disable_execute_api_endpoint = true
}

############### Route53 & ACM data source ###############

data "aws_acm_certificate" "api-gateway" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "root_domain" {
  name         = var.domain_name
  private_zone = false
}

############### Custom Domain Name and Register in R53 ###############

resource "aws_apigatewayv2_domain_name" "domain_name" {
  domain_name = "${var.sub_domain_name}.${var.domain_name}"

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.api-gateway.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "sub_domain" {
  name    = var.sub_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.root_domain.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.domain_name.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain_name.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

############### Cloudwatch setup ###############

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.this.name}"

  retention_in_days = var.retention_in_days
}

############### Create stages ###############

resource "aws_apigatewayv2_stage" "this" {
  for_each = toset(var.stages)
  api_id   = aws_apigatewayv2_api.this.id

  name        = each.key
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      basePath                = "$context.customDomain.basePathMatched"
      }
    )
  }
}
