resource "aws_subnet" "DemoPublicSubnet" {
  vpc_id     = aws_vpc.DemoVPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "DemoPublicSubnet"
  }
}