#KEY PAIR FOR EC2 INSTANCE

resource "aws_key_pair" "deployer" {
    key_name   = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")

}

#VPC & SECURITY GROUPS

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "name" {
  
}