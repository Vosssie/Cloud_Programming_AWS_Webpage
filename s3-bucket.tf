resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket #
  region = var.region

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#REPLACES acl = "private in 'aws_s3_bucket' deprecated in this version"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_s3_bucket_ownership_controls" "Bucket-Ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
#ACCESS CONTROL LIST
resource "aws_s3_bucket_acl" "Bucket-ACL" {
  depends_on = [aws_s3_bucket_ownership_controls.Bucket-Ownership]

  bucket = aws_s3_bucket.bucket.id
  acl    = "private" # Set to private
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#REPLACES website in "aws_s3_bucket" deprecated in this version
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_s3_bucket_website_configuration" "bucket-config" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/" # Object key name prefix when the redirect is applied
    }
    redirect {
      replace_key_prefix_with = "documents/" # redirect requests for all pages with prefix docs/ (objects in the docs/ folder) to documents/
    }
  }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#REPLACES versioning in "aws_s3_bucket" deprecated in this version
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#REPLACES server_side_encryption_configuration in "aws_s3_bucket" deprecated in this version
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_s3_bucket_server_side_encryption_configuration" "server-side-encrypt" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256" # Encryption algorithm applied
    }
  }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#REPLACES lifecycle_rule in "aws_s3_bucket" deprecated in this version
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_s3_bucket_lifecycle_configuration" "bucket-lifecycle" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "rule-1"
    transition {
      days = 30   #Number of days after creation when objects are transitioned to the specified storage class. Default 0
      storage_class = "STANDARD_IA" #Storage class: Glacier etc
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin-access-id.id}"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.bucket.arn}/*"
      }
    ]
  })
}