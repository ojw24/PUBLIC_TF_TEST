terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 의도적 위반: 암호화/버저닝/로깅/퍼블릭 액세스 차단 미설정
resource "aws_s3_bucket" "test_bucket" {
  bucket = "checkov-public-test-bucket-${var.env}"
}

resource "aws_s3_bucket_public_access_block" "test_bucket_pab" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 의도적 위반: 0.0.0.0/0 전체 허용 인바운드
resource "aws_security_group" "test_sg" {
  name        = "checkov-public-test-sg"
  description = "Intentionally insecure SG for Checkov test"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 의도적 위반: 암호화되지 않은 EBS 볼륨
resource "aws_ebs_volume" "test_volume" {
  availability_zone = "${var.aws_region}a"
  size              = 10
  encrypted         = false
}
