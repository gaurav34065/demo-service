resource "aws_security_group" "DemoAllowSsh" {
  name        = "DemoAllowSsh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.DemoVPC.id

  ingress {
    description      = "Allow SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DemoAllowSsh"
  }
}

resource "aws_security_group" "DemoAppAccess" {
  name        = "DemoAppAccess"
  description = "Allow app inbound traffic"
  vpc_id      = aws_vpc.DemoVPC.id

  ingress {
    description      = "Allow app access from anywhere"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DemoAppAccess"
  }
}