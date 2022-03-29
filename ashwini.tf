
provider "aws" {
  profile = "user1"  
  region  = "us-east-2"
}
resource "aws_instance" "ec2demo" {
  ami= "ami-064ff912f78e3e561"
  instance_type = "t2.micro"

  tags ={
   Name = "First Instance"
  }
}
resource "aws_ebs_volume" "ebs-vol" {
 availability_zone = aws_instance.ec2demo.availability_zone
 size = 1
 tags = {
        Name = "extra-ebs"
}

}
#

resource "aws_volume_attachment" "attach_ebs_2" {
 device_name = "/dev/sdh"
 volume_id = aws_ebs_volume.ebs-vol.id
 instance_id = aws_instance.ec2demo.id
}

resource "aws_eip" "eip" {
  instance = aws.instance.ec2demo.id
  vpc = true 
}
resource "aws_security_group" "security-ssh" {
  name = "ashwini-security-group"

  #Incoming traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["203.192.214.58/32"]
  }

  #Outgoing traffic
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}