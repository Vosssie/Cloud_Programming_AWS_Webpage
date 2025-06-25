resource "aws_route53_zone" "Hosted-Zone" {
  name = var.domain
}

resource "aws_route53_record" "website" {
  zone_id = aws_route53_zone.Hosted-Zone.zone_id
  name    = var.domain
  type    = "A" #Record Type. A is example value used

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

## REPEAT for ALL website aliases
resource "aws_route53_record" "www-infront" {
  zone_id = aws_route53_zone.Hosted-Zone.zone_id
  #name    = "www.${var.domain}$"
  name = var.domain
  type    = "A" #Record Type. A is example value used

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}