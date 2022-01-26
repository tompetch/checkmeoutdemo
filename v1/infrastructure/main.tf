terraform {
  backend "s3" {
    # Bucket name
    bucket         = "checkmeoutdemoterraformstate"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
    # DynamoDB table name
    dynamodb_table = "checkmeoutdemoterraformstatelock"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "checkmeoutdemo.tompetch.com"
  acl    = "public-read"
    
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

resource "aws_s3_bucket_object" "index_html_upload" {

  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  acl    = "public-read"
  content = "./v1/application/index.html"
  kms_key_id = aws_kms_key.mykey.arn

}