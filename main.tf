data "aws_ami" "app_ami" {
  owners      = ["amazon"]
  most_recent = true


  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10**"]
  }
}
resource "aws_instance" "instance-1" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
  key_name = "terraform"
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("terraform.pem")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1",
      "sudo systemctl start nginx"
    ]
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.instance-1.private_ip} >> private_ips.txt"
  }
  
 
}
output "mypublicIP" {
  value = aws_instance.instance-1.public_ip
}
