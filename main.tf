resource "aws_s3_bucket" "my-s3-bucket" {
  bucket = var.bucket_name
  force_destroy = true


  tags = {
    Name : "terraform"
  }
}

resource "aws_s3_bucket_acl" "my-s3-bucket-acl" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3-versioning" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "some_bucket_config" {
  bucket = aws_s3_bucket.some_bucket.id
  rule {
    id = "move-to-ia-or-glacier"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }
}

