output "website_url" {
  value = "https://${var.domain}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.user-pool.id
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "cognito_domain" {
  value = aws_cognito_user_pool_domain.user-pool-domain.domain
}