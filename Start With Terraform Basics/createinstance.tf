resource "aws_instance" "MyFirstInstance" {
    ami = "ami-0b6b93913be33d8f6"
    instance_type = "t2.micro"
}