variable "lambda_function_name" {
  default = "lambda_function_name"
}
variable "github_token" {
  default = "github token"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "lambda_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "lambda:CreateFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:GetFunction",
    ]
  }
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}

resource "aws_iam_role" "pipeline_role" {
  name = "lambda-pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "build_role" {
  name = "lambda-build-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

    tags = {
    "Name" = "lambda-VPC"
  }
}

resource "aws_security_group" "lambda_allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.vpc.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_subnet" "lambda_private_subnet" {

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1"

  tags = {
    "Name" = "lambda-private-subnet"
  }
}

resource "aws_subnet" "lambda_public_subnet" {

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "lambda-public-subnet"
  }
}

resource "aws_internet_gateway" "lambda_ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "lambda-internet-gateway"
  }
}

resource "aws_route_table" "route-table-public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lambda_ig.id
  }

  tags = {
    "Name" = "proute-table-public"
  }
}

resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.lambda_public_subnet.id
  route_table_id = aws_route_table.route-table-public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "lambda_nat_gateway" {
  depends_on = [aws_internet_gateway.lambda_ig]

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.lambda_public_subnet.id

  tags = {
    Name = "Public NAT"
  }
}

resource "aws_route_table" "lambda_private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.lambda_nat_gateway.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "public_private" {
  subnet_id      = aws_subnet.lambda_private_subnet.id
  route_table_id = aws_route_table.lambda_private.id
}



data "archive_file" "lambda_source_code" {
  type = "zip"

  source_dir  = "${path.module}/source-code"
  output_path = "${path.module}/source-code/be.zip"
}

resource "aws_lambda_function" "rtc_lambda" {
  function_name = var.lambda_function_name
  filename       = "${path.module}/source-code/be.zip"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.js"
  source_code_hash = data.archive_file.lambda_source_code.output_base64sha256

  runtime = "nodejs16.x"

  ephemeral_storage {
    size = 512 # Min 512 MB and the Max 10240 MB
  }

  vpc_config {
    subnet_ids         = [aws_subnet.lambda_private_subnet.id]
    security_group_ids = [aws_security_group.lambda_allow_tls.id]
  }

  environment {
    variables = {
      VUE_APP_API_URL = "thopt.website"
      NEST_APP_API_URL= "api.thopt.website"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.cloudwatch_lambda_group,
    aws_efs_mount_target.alpha,
    aws_internet_gateway.lambda_ig,
  ]
}

# EFS file system
resource "aws_efs_file_system" "efs_for_lambda" {
  tags = {
    Name = "efs_for_lambda"
  }
}

# Mount target connects the file system to the subnet
resource "aws_efs_mount_target" "alpha" {
  file_system_id  = aws_efs_file_system.efs_for_lambda.id
  subnet_id       = aws_subnet.lambda_private_subnet.id
  security_groups = [aws_security_group.lambda_allow_tls.id]
}

# EFS access point used by lambda file system
resource "aws_efs_access_point" "access_point_for_lambda" {
  file_system_id = aws_efs_file_system.efs_for_lambda.id

  root_directory {
    path = "/lambda"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "777"
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_lambda_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}


resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
