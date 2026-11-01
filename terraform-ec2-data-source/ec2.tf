resource "aws_instance" "ProductServer" {
    ami = "ami-03f1d2b3639314198"
    availability_zone = "ap-south-2a"
    instance_type = "t3.micro"
    key_name = "Hyd.key"
    subnet_id = "${data.aws_subnet.Terraform_Public_Subnet1-testing.id}"
    vpc_security_group_ids = ["${data.aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    tags = {
        Name = "Server-1"
    }
}

terraform {
  backend "s3" {
    bucket = "backend-bucket-for-terraform-chandu1"
    key    = "ec2-terraform.tfstate"
    region = "ap-south-2"
  }
}
