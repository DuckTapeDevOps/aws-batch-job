variable "private_subnets" {
  description = "A list of private subnets to use for the AWS Batch compute environment."
   type = list(object({
    arn          = string
    aws_zone    = string
    cidr        = string
  }))
  default = [
        {
          "arn": "arn:aws:ec2:us-east-1:375112818203:subnet/subnet-06d4b46edb3da788d",
          "aws_zone": "us-east-1a",
          "cidr": "10.0.0.0/23"
        },
        {
          "arn": "arn:aws:ec2:us-east-1:375112818203:subnet/subnet-0f96b85597f93f66c",
          "aws_zone": "us-east-1b",
          "cidr": "10.0.2.0/23"
        },
        {
          "arn": "arn:aws:ec2:us-east-1:375112818203:subnet/subnet-0e4d92b94cff1981c",
          "aws_zone": "us-east-1c",
          "cidr": "10.0.4.0/23"
        },
        {
          "arn": "arn:aws:ec2:us-east-1:375112818203:subnet/subnet-096c251ea1228546f",
          "aws_zone": "us-east-1d",
          "cidr": "10.0.6.0/23"
        }
  ]
}

