data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "bastion" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t3.micro"
  tags = {
    Name        = "bastion-ec2"
  }
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion.id]
}

