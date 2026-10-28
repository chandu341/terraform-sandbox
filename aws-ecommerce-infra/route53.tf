
resource "aws_route53_zone" "public" {
  count = var.create_hosted_zone ? 1 : 0

  name = var.domain_name

  tags = { Name = "${var.project_name}-public-zone" }
}

locals {
  hosted_zone_id = (
    var.create_hosted_zone
    ? aws_route53_zone.public[0].zone_id
    : ""
  )
}

resource "aws_route53_record" "shop" {
  zone_id = local.hosted_zone_id
  name    = local.app_hostname
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }

  depends_on = [
    aws_acm_certificate_validation.shop
  ]
}
