provider "aws" {
        region = "us-east-1"
        profile = "default"


}


resource "aws_s3_bucket" "b" {
  bucket = "random-buvket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_object" "object" {
  bucket = "random-buvket"
  key    = "random_key"
  source = "out.txt"

  etag = "${filemd5("out.txt")}"
}

resource "aws_iam_role" "lambda_function_python" {
  name = "lambda_function_python"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_s3_access" {
  name        = "lambda_s3_access"
  path        = "/"
  description = "IAM policy for s3"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}

EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = "${aws_iam_role.lambda_function_python.name}"
  policy_arn = "${aws_iam_policy.lambda_s3_access.arn}"
}


resource "aws_lambda_function" "lamdba_random_file_python" {
  filename      = "code.zip"
  function_name = "lamdba_random_file_python"
  role          = "${aws_iam_role.lambda_function_python.arn}"
  handler       = "lambda_function.lambda_handler"

  source_code_hash = "${filebase64sha256("code.zip")}"

  runtime = "python3.7"


}

