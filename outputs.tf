output "bucket_name" {
  value = aws_s3_bucket.test_bucket.bucket
}
output "sg_id" {
  value = aws_security_group.test_sg.id
}
