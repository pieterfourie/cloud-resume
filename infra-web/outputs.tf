output "bucket_name" {
  value = aws_s3_bucket.site.bucket
}
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}
output "website_url" {
  value = "https://${local.fqdn}"
}
