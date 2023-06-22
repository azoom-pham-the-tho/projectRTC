data "archive_file" "source_fe" {
  type = "zip"
  source_dir  = "${path.module}/../vue-rtc"
  output_path = "${path.module}/source-code/vue-rtc.zip"
}
data "archive_file" "source_be" {
  type = "zip"
  source_dir  = "${path.module}/../nest-server-rtc"
  output_path = "${path.module}/source-code/nest-server-rtc.zip"
}
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "projectrtc"

  tags = {
    Name        = "Lambda bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "s3_object_fe" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "vue-rtc.zip"
  source = data.archive_file.source_fe.output_path

  etag = filemd5(data.archive_file.source_fe.output_path)
}

resource "aws_s3_object" "s3_object_be" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "nest-server-rtc.zip"
  source = data.archive_file.source_be.output_path

  etag = filemd5(data.archive_file.source_be.output_path)
}
