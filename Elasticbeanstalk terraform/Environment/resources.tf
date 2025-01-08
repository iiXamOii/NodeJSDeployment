data "aws_region" "current" {}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["nodejs Application Primary VPC"]
  }
}
data "aws_subnet" "main" {
  filter {
    name   = "tag:Name"
    values = ["Public Subnet 1"]
  }
}

resource "aws_elastic_beanstalk_application" "main" {
  name        = "node-${var.suffix}"
  description = "Node Test Application in Dev Environment"

  appversion_lifecycle {
    service_role          = aws_iam_role.main.arn
    max_count             = 128
    delete_source_from_s3 = true
  }
}
resource "aws_elastic_beanstalk_environment" "main" {
  name                = "Beanstalk-${var.suffix}-Environment"
  application         = aws_elastic_beanstalk_application.main.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.4.1 running Node.js 22"
  tier                = "WebServer"
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = data.aws_vpc.main.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = data.aws_subnet.main.id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.subject_profile.name
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "True"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
}
output "aws_elastic_beanstalk_environment" {
  value = aws_elastic_beanstalk_environment.main.endpoint_url
}
output "aws_beanstalk_app" {
  value = aws_elastic_beanstalk_application.main.arn
}

