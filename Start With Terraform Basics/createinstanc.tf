provider "aws" {
    access_key = "AKIAZUDEURZVJMRXEHFQ"
    secret_key = "SECRET_KEY"
    region = "us-east-2"
}

resource "aws_instance" "MyFirstInstance" {
    ami = "ami-0b6b93913be33d8f6"
    instance_type = "t2.micro"
}