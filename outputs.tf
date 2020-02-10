output "acm_certificate_arn" {
  value = data.aws_acm_certificate.cert.arn
}

output "cloudfront_hostname" {
  value = aws_cloudfront_distribution.hugo[0].domain_name
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.hugo[0].hosted_zone_id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.hugo.arn
}
