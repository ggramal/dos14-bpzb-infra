resource "aws_route53_zone" "bpzb" {
  name = var.zone_name
}

resource "aws_route53_record" "api_bpzb_a" {
  name    = var.a_record_name
  type    = var.a_record_type
  zone_id = aws_route53_zone.bpzb.zone_id
  alias {
    name                   = var.route53_alb_dns_name
    zone_id                = var.route53_alb_zone_id
    evaluate_target_health = var.a_target_health
  }
  depends_on = [aws_route53_zone.bpzb]
}

resource "aws_acm_certificate" "api_bpzb" {
  domain_name       = var.cert_domain_name
  validation_method = var.cert_validation_method
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_bpzb_cname" {
  for_each = {
    for dvo in aws_acm_certificate.api_bpzb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = var.cname_overwrite
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.cname_ttl
  type            = each.value.type
  zone_id         = aws_route53_zone.bpzb.zone_id
  depends_on      = [aws_route53_zone.bpzb, aws_acm_certificate.api_bpzb]
}

resource "aws_acm_certificate_validation" "api_bpzb" {
  certificate_arn         = aws_acm_certificate.api_bpzb.arn
  validation_record_fqdns = [for record in aws_route53_record.api_bpzb_cname : record.fqdn]
}

