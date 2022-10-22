resource "aws_route_table" "DemoRouteTablePublic" {
  vpc_id = aws_vpc.DemoVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.DemoInternetGateway.id
  }

  tags = {
    Name = "DemoRouteTablePublic"
  }
}

resource "aws_route_table_association" "rt-Demo-association" {
  subnet_id      = aws_subnet.DemoPublicSubnet.id
  route_table_id = aws_route_table.DemoRouteTablePublic.id
}