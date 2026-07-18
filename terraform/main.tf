data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "k3s_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "k3s-vpc"
  }
}

resource "aws_subnet" "k3s_subnet" {
  vpc_id                  = aws_vpc.k3s_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "k3s-subnet"
  }
}

resource "aws_internet_gateway" "k3s_igw" {
  vpc_id = aws_vpc.k3s_vpc.id

  tags = {
    Name = "k3s-igw"
  }
}

resource "aws_route_table" "k3s_rt" {
  vpc_id = aws_vpc.k3s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k3s_igw.id
  }

  tags = {
    Name = "k3s-rt"
  }
}

resource "aws_route_table_association" "k3s_rta" {
  subnet_id      = aws_subnet.k3s_subnet.id
  route_table_id = aws_route_table.k3s_rt.id
}

resource "aws_security_group" "k3s_sg" {
  name        = "k3s-sg"
  description = "Security group for k3s cluster nodes"
  vpc_id      = aws_vpc.k3s_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all internal traffic between nodes (if scaling past 1 node)
  ingress {
    description = "Internal Node Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k3s-sg"
  }
}

# Conditionally create SSH key if not provided
resource "tls_private_key" "k3s_key" {
  count     = var.ssh_key_name == "" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "k3s_key_pair" {
  count      = var.ssh_key_name == "" ? 1 : 0
  key_name   = "k3s-starter-key"
  public_key = tls_private_key.k3s_key[0].public_key_openssh
}

resource "local_file" "private_key" {
  count           = var.ssh_key_name == "" ? 1 : 0
  content         = tls_private_key.k3s_key[0].private_key_pem
  filename        = "${path.module}/k3s-starter-key.pem"
  file_permission = "0400"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "k3s_node" {
  count                  = var.node_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.k3s_subnet.id
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]
  key_name               = var.ssh_key_name != "" ? var.ssh_key_name : aws_key_pair.k3s_key_pair[0].key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "k3s-node-${count.index + 1}"
  }
}
