data "aws_route53_zone" "zone" {
  name = "${var.domain_name}."
}

module "acm" {
  source                    = "git::https://github.com/terraform-aws-modules/terraform-aws-acm.git//?ref=v3.2.0"
  create_certificate        = true
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  wait_for_validation       = false
  zone_id                   = data.aws_route53_zone.zone.id
}