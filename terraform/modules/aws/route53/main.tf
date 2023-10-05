resource "aws_route53_zone" "bpzb" {
  name = var.dns_name
  #  private_zone = var.dns_private_zone
}

resource "aws_route53_record" "api_bpzb" {
  name    = var.dns_record_name
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = aws_route53_zone.bpzb.name_servers
  ####
  #  for_each = {
  #  for dvo in aws_acm_certificate.api_bpzb.domain_validation_options : dvo.domain_name => {
  #    name   = dvo.resource_record_name
  #    record = dvo.resource_record_value
  #    type   = dvo.resource_record_type
  #  }
  #}
  #allow_overwrite = true
  #name            = each.value.name
  #records         = [each.value.record]
  #ttl             = 60
  #type            = each.value.type
  zone_id = aws_route53_zone.bpzb.zone_id
}

resource "aws_acm_certificate" "api_bpzb" {
  domain_name       = var.dns_record_name
  validation_method = var.dns_validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "api_bpzb" {
  certificate_arn         = aws_acm_certificate.api_bpzb.arn
  validation_record_fqdns = [aws_route53_record.api_bpzb.fqdn] #[for record in aws_route53_record.api_bpzb : record.fqdn]
}

