resource "aws_cloudfront_origin_access_identity" "origin-access-id" {
  comment = "OAI for website (4seeable.co.za)"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = "S3Origin"  # Simplified origin ID

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin-access-id.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for 4seeable.co.za"
  default_root_object = "index.html"  # Removed leading slash

  aliases = [var.domain]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]  # Reduced methods for static content
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"  # Must match origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"  # Best practice
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true  # Added compression
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      # Explicit empty locations list (required even with 'none')
      locations = []
    }
  }

  viewer_certificate {
    #acm_certificate_arn      = aws_acm_certificate.acm-cert.arn
    acm_certificate_arn = "arn:aws:acm:us-east-1:247387203355:certificate/6144c5b3-3fb9-4484-9211-65aaf9ed930f"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"  # Updated version
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 404  # Changed to return actual 404
    response_page_path    = "/error.html"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = "production"
  }
}