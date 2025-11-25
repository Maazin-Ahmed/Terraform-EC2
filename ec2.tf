#KEY PAIR FOR EC2 INSTANCE

resource "aws_key_pair" "deployer" {
    key_name   = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")

}

#VPC & SECURITY GROUPS

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "watchman_sg" {

    name        = "watchman_sg"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id      = aws_default_vpc.default.id #interpolation

    #inbound rules

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH access from anywhere"
    }
    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP access from anywhere"
    }
    ingress {
        from_port = 8000
        to_port   = 8000
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Custom application access from anywhere"
    }

    #outbound rules

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "watchman_sg"
    }
}

#EC2 INSTANCE

resource "aws_instance" "terraform-ec2" {
    key_name = aws_key_pair.deployer.key_name #interpolation
    security_groups = [ aws_security_group.watchman_sg.name ]
    instance_type = "t2.micro "
    ami = "ami-02b8269d5e85954ef"

    root_block_device {
      volume_size = 8
      volume_type = "gp3"
    }
    tags = {
        Name = "terraform-ec2"
    }
}