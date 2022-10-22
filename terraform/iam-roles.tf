resource "aws_iam_role" "build_server_role" {
  name               = "build-server-role"
  assume_role_policy = "${file("iam-policies/trust-entities.json")}"
}

resource "aws_iam_policy" "ecr_registry_access" {
  name        = "ecr-registry-access"
  description = "ecr-registry-access policy"
  policy      = "${file("iam-policies/ecr-registry-access.json")}"
}

resource "aws_iam_policy_attachment" "build_ecr_attachment" {
  name       = "build-ecr-attachment"
  roles      = ["${aws_iam_role.build_server_role.name}"]
  policy_arn = "${aws_iam_policy.ecr_registry_access.arn}"
}

resource "aws_iam_instance_profile" "build_server_profile" {
  name = "build-server-profile"
  role = aws_iam_role.build_server_role.name
}