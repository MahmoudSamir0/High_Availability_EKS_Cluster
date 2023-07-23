output "bucket-arn" {
  value = aws_s3_bucket.tf-state.arn
}

output "bucket-name" {
  value = aws_s3_bucket.tf-state.bucket
}
output "bucket-id" {
  value = aws_s3_bucket.tf-state.id
}       
output "domain" {
  value = aws_s3_bucket.tf-state.bucket_regional_domain_name
}