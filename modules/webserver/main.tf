# Création de l'instance EC2

# Récupération dynamique de l'AMI
data "aws_ami" "latest_amz_linux_img" {
    most_recent      = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = [var.image_name]
    }
}

# Création de la clé ssh
resource "aws_key_pair" "accor_ec2_key" {
    key_name   = "ec2-key"
    public_key = file(var.public_key_ssh_location)
} 


# Création de l'instance 
resource "aws_instance" "accor_ec2" {

    #1. Choose AMI
    ami = data.aws_ami.latest_amz_linux_img.id

    #2. Choose instance type
    instance_type = var.instance_type

    #3. Assign SSH key 
    key_name = aws_key_pair.accor_ec2_key.key_name

    vpc_security_group_ids = [ var.sg_id ]

    associate_public_ip_address = true
 
    connection {
      type = "ssh"
      user = "ec2-user"
      host = self.public_ip
      private_key = file(var.private_key_location)
    }

    provisioner "file" {
        source = "entrypoint.sh"
        destination = "/home/ec2-user/entrypoint.sh"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /home/ec2-user/entrypoint.sh",
          "/home/ec2-user/entrypoint.sh"
        ]
    }

    tags = {
       Name = "${var.env_prefix}-ec2"
    }
}
