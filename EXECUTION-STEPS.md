Author : Gaurav Sharma </br>
Email  : gaurav_sharma34065@yahoo.com

## Description

This solution creates all the necessary infra resources in AWS cloud for the build and deployment of application.
IaC tool used is Terraform and Configuration management tool used is Ansible.
Design includes a build-server where docker build takes place and an app-server where actual api container runs.

### Steps involved are :
- Terraform creates VPC, subnet, route-table, Security groups, Internet gateway and IAM role as part of basic infra.
- First, build-server is launched where Ansible execution happens which takes care of utilities like git, docker, aws cli install.
- Application image is built and it pushed to a public registry which i have already created.
- Second, app-server is launched where Ansible execution happens which takes care of utilities like git, docker, aws cli install.
- Image get's pulled from registry and container creation takes place.
- Once Container is up, user can access API on EC2 instance public IP at app port 3000.

## How to do it in your local:

### prerequisites :
- You need an AWS account.
- An AWS user needs to be created which has programatic access to the account and has `policy : AdministratorAccess` so that it can manage resources.
- Latest version of Terraform should be installed.

### Execution Steps :
- Make a git clone of this repository.
- I used region `ap-south-1`, you can use your own region, but make sure to change references in `provider.tf` & `subnet.tf`
- (Optional) You can create ssh-key pair and provide public key in `ec2.tf` `public_key` variable. The public key which is currently present is mine and won't work for you.
- Export credentials for your user using which terraform can access AWS resources
```
export AWS_ACCESS_KEY_ID= <ID>
export AWS_SECRET_ACCESS_KEY= <KEY>
```
- run `$cd demo-service/terraform`
- run `$terraform init`
- run `$terraform apply -auto-approve`
- Execution will run nearly for 13-15 mins.
- Once completed you'll see output like below
```
Outputs:
DemoAppPublicIp = "43.XX.XX.63"
```
- You can go to your browser and enter below url to see the API working </br>
`http://43.XX.XX.63:3000/api/v1/users`

- (Optional) I have kept open ssh port to troubleshoot anyting if required, You can use below command to login if needed after creation.
```
$ ssh -i ~/.ssh/private_key ec2-user@<EC2-Public-Ip>
```
Do a sudo and access `/var/log/cloud-init-output.log`

### NOTE :
- I have excluded many features like replications, Load Balancers, NAT gateways as this exercise was done on a free tier.
- To keep code simple to understand and test, i did not use terraform modules, variables etc.
- Due to the time constraint i left few things which we can automate and simplify here.
