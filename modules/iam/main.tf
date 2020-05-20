provider "aws" {
  region = var.region
}

resource "aws_iam_group" "admin-us-eu" {
  name = "AdministratorAccess-US-EU"
}

resource "aws_iam_group_policy" "admin-us-eu" {
  name   = "AdministratorAccess-US-EU"
  group  = aws_iam_group.admin-us-eu.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "us-east-2",
                        "us-west-1",
                        "us-west-2",
                        "eu-central-1",
                        "eu-west-1",
                        "eu-west-2",
                        "eu-west-3",
                        "eu-north-1",
                        "eu-south-1"
                    ]
                }
            }
        }
    ]
}
EOF
}