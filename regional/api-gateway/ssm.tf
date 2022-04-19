resource "aws_ssm_parameter" "this" {
  name  = var.api_gw_name
  type  = "String"
  value = aws_apigatewayv2_api.this.id
}
