output "DemoAppPublicIp" {
    value = "${aws_instance.DemoAppServer.public_ip}"
}