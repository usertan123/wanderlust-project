resource "aws_key_pair" "instance-key" {
  key_name   = "${var.tags}-key"
  public_key = file("/mnt/c/Users/tanmay badwaik/Desktop/id_rsa.pub")
}

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "allow_tls" {
  name        = "${var.tags}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  

  tags = {
    Name = "${var.tags}-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    # values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20250305"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["481665112268"] # Canonical
}

resource "aws_instance" "project" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  security_groups = [aws_security_group.allow_tls.name]
  key_name = aws_key_pair.instance-key.key_name
  tags = {
    Name = "${var.tags}-instance"
  }
}
