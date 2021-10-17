data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "auth" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "web" {
  count = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "${var.name}-${count.index}"
    Owner = var.owner
  }
  key_name = aws_key_pair.auth.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id = var.public_subnets[count.index]

  connection {
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source = "scripts/nginx.py"
    destination = "/tmp/nginx.py"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.private_key_path)
    }
    inline = [
      "sudo /usr/bin/python3 /tmp/nginx.py ${self.id}"
    ]
  }
}

resource "aws_lb_target_group_attachment" "tg_attach" {
  count = var.instance_count
  target_group_arn = var.lb_target_group_arn
  target_id = aws_instance.web[count.index].id
  port = 80
}

