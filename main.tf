# ------------------
# VPC
# ------------------

resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "DevOps-VPC"
  }
}

# ------------------
# INTERNET GATEWAY
# ------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "DevOps-IGW"
  }
}

# ------------------
# PUBLIC SUBNET
# ------------------

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

# ------------------
# ROUTE TABLE
# ------------------

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# ------------------
# ROUTE TABLE ASSOCIATION
# ------------------

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ------------------
# SECURITY GROUP
# ------------------

resource "aws_security_group" "devops_sg" {
  vpc_id = aws_vpc.devops_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOps-SG"
  }
}

# ------------------
# EC2 INSTANCE KEY
# ------------------

resource "aws_key_pair" "devops" {
  key_name   = "devops-key"
  public_key = file("devops-key.pub")
}

# ------------------
# EC2 INSTANCES
# ------------------

resource "aws_instance" "jenkins_server" {

  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id

  key_name      = aws_key_pair.devops.key_name

  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_instance" "k8_master" {

  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id

  key_name = aws_key_pair.devops.key_name

  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "Kubernetes-Master"
  }
}

resource "aws_instance" "k8_worker" {

  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id

  key_name = aws_key_pair.devops.key_name

  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "Kubernetes-Worker"
  }
}