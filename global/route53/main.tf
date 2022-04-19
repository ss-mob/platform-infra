module "public-domain" {
  source = "git::https://github.com/ss-mob/aws-terraform-modules.git//route53/zone?ref=main"
  zone = {
    domain = var.domain_name
  }
}