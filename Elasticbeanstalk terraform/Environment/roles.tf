resource "aws_iam_role" "main" {
  name = "beanstalk-${var.suffix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "elasticbeanstalk.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    tag-key = "beanstalk-role"
  }
}
resource "aws_iam_instance_profile" "subject_profile" {
  name = "beanstalk-${var.suffix}-instance-profile"
  role = aws_iam_role.main.name
}
resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
  ])

  role       = aws_iam_role.main.name
  policy_arn = each.value
}
resource "aws_iam_role_policy" "main" {
  name = "Beanstalk-${var.suffix}-Role-Policy"
  role = aws_iam_role.main.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudformationReadOperationsOnElasticBeanstalkStacks",
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:DescribeStackResource",
          "cloudformation:DescribeStackResources",
          "cloudformation:DescribeStacks"
        ],
        "Resource" : [
          "arn:aws:cloudformation:*:*:stack/awseb-*",
          "arn:aws:cloudformation:*:*:stack/eb-*"
        ]
      },
      {
        "Sid" : "AllowOperations",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeNotificationConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:PutNotificationConfiguration",
          "ec2:DescribeInstanceStatus",
          "ec2:AssociateAddress",
          "ec2:DescribeAddresses",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "elasticloadbalancing:DescribeInstanceHealth",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeTargetGroups",
          "lambda:GetFunction",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sns:Publish"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Sid" : "AllowOperationsOnHealthStreamingLogs",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:DeleteLogGroup",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk/*"
      }
    ]
  })
}
resource "aws_iam_policy" "main" {
  name        = "Beanstalk-${var.suffix}-iam-Policy"
  path        = "/"
  description = "Iam Policy"


  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudformationReadOperationsOnElasticBeanstalkStacks",
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:DescribeStackResource",
          "cloudformation:DescribeStackResources",
          "cloudformation:DescribeStacks"
        ],
        "Resource" : [
          "arn:aws:cloudformation:*:*:stack/awseb-*",
          "arn:aws:cloudformation:*:*:stack/eb-*"
        ]
      },
      {
        "Sid" : "AllowOperations",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeNotificationConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:PutNotificationConfiguration",
          "ec2:DescribeInstanceStatus",
          "ec2:AssociateAddress",
          "ec2:DescribeAddresses",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "elasticloadbalancing:DescribeInstanceHealth",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeTargetGroups",
          "lambda:GetFunction",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sns:Publish"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Sid" : "AllowOperationsOnHealthStreamingLogs",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:DeleteLogGroup",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk/*"
      }
    ]
  })
}
resource "aws_iam_policy_attachment" "main" {
  name       = "Beanstalk-${var.suffix}-role-attachment"
  roles      = [aws_iam_role.main.name]
  policy_arn = aws_iam_policy.main.arn
}
