resource "aws_internet_gateway" "DemoInternetGateway" {
  vpc_id = aws_vpc.DemoVPC.id

  tags = {
    Name = "DemoInternetGateway"
  }
}