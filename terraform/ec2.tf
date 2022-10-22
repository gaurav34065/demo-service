resource "aws_instance" "DemoBuildServer" {
  ami             = "ami-01216e7612243e0ef"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.DemoPublicSubnet.id
  security_groups = [aws_security_group.DemoAllowSsh.id]
  key_name        = aws_key_pair.DemoSshKey.id
  tags = {
    Name = "DemoBuildServer"
  }

  user_data = <<EOF
    #! /bin/bash
    sudo amazon-linux-extras install ansible2 -y
    sudo yum install git -y
    cd /root
    git clone https://github.com/gaurav34065/demo-service.git
    cd demo-service/ansible
    ansible-playbook prerequisites.yaml
    cd /root
    git clone https://github.com/CareerFoundry-Engineering/practicum-devops.git
    cd practicum-devops/api
    make build
    aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/x3x5v0n7
    docker tag practicum.rails.api:latest public.ecr.aws/x3x5v0n7/demoregistry:practicum.rails.api.latest
    docker push public.ecr.aws/x3x5v0n7/demoregistry:practicum.rails.api.latest
    EOF

  iam_instance_profile = aws_iam_instance_profile.build_server_profile.name

  provisioner "local-exec" {
    command = "sleep 7m"
  }

}

resource "aws_instance" "DemoAppServer" {
  depends_on      = [aws_instance.DemoBuildServer]
  ami             = "ami-01216e7612243e0ef"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.DemoPublicSubnet.id
  security_groups = [aws_security_group.DemoAllowSsh.id, aws_security_group.DemoAppAccess.id]
  key_name        = aws_key_pair.DemoSshKey.id
  tags = {
    Name = "DemoAppServer"
  }

  user_data = <<EOF
    #! /bin/bash
    sudo amazon-linux-extras install ansible2 -y
    sudo yum install git -y
    cd /root
    git clone https://github.com/gaurav34065/demo-service.git
    cd demo-service/ansible
    ansible-playbook prerequisites.yaml
    cd /root
    aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/x3x5v0n7
    docker pull public.ecr.aws/x3x5v0n7/demoregistry:practicum.rails.api.latest
    docker tag public.ecr.aws/x3x5v0n7/demoregistry:practicum.rails.api.latest api-practicum.rails.api
    docker tag api-practicum.rails.api practicum.rails.api:latest
    git clone https://github.com/CareerFoundry-Engineering/practicum-devops.git
    cd practicum-devops/api
    make prepare
    make up
    EOF

  iam_instance_profile = aws_iam_instance_profile.build_server_profile.name

  provisioner "local-exec" {
    command = "sleep 5m"
  }

}

resource "aws_key_pair" "DemoSshKey" {
  key_name   = "DemoSshKey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDp3f+OMxSwqtJPfxlVvMQdQLQ8Q8FUU8Tc3QBcGQb7xB/r0iE92/hEJT9X6QSC8FuViHwypM+AzSxyWLhfOkoX2Z9MLifY/KXRi4KXmSIfN+GF+lPvyuMAje3yHuhM1W9TmZdJ9sKRnFuni+Te2V7otKv35VR2DIyDXpolhafaS/j5rhguMI+hnzQfoaVUXPt/UgDL9PRo7p12AgW9thet2dfi+ameY0TrAwh4Go51L273Cp905Q42UwNhc9DnGk7EnYyoZ2a0kWNqbmnHbxO+vNUKVnVVLNTKDJwAc4JR0yQQMdgJgjq0xrJhe5dc/bNijs1EQoNc2eHBjEUUX0Af gauravnsharma@gaurav.sharma-C02QQ49MG8WP"
}