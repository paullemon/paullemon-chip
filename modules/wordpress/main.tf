provider "aws" {
  region = var.region
}
data "aws_vpc" "vpc" {
  tags = {
    Name = "Spacely Sprockets - Application - VPC"
  }
}
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = "Spacely Sprockets - Application - Public Subnet*"
  }
}
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = "Spacely Sprockets - Application - Private Subnet*"
  }
}

## RDS
resource "aws_security_group" "sg-db-wordpress" {
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    protocol    = 6
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.default_tags["Project"]} - Application - Wordpress DB"
    )
  )
}
resource "aws_db_instance" "wordpress" {
  allocated_storage    = var.db_volume
  storage_type         = "gp2"
  db_subnet_group_name = aws_db_subnet_group.wordpress.id
  engine               = "mysql"
  engine_version       = "5.7.28"
  instance_class       = var.db_size
  name                 = "ebdb"
  multi_az             = true
  identifier           = "ebdb"
  #final_snapshot_identifier = "${var.tenant_env}-db-wordpress-final-snapshot"
  skip_final_snapshot    = true
  username               = var.username
  password               = var.password
  vpc_security_group_ids = [aws_security_group.sg-db-wordpress.id]
  tags = merge(
    { Name = "${var.default_tags["Project"]} - Application - Wordpress DB" },
    var.default_tags
  )
}
resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress"
  subnet_ids = data.aws_subnet_ids.private.ids
  tags = merge(
    { Name = "${var.default_tags["Project"]} - Application - Wordpress DB SubnetGroup" },
    var.default_tags
  )
}

## Front End
resource "aws_security_group" "wordpress" {
  name   = "TFE Bastion"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { Name = "Application Wordpress" },
    var.default_tags
  )
}
resource "aws_key_pair" "wordpress" {
  key_name   = "wordpress"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAhWyC88zOQupw7jIbASm5g3fBRggAMWvL8zU4TN7aI3B92FaJVQeENdhY/V/9URh9/1AOc4NjbFy9JpIXRavYJi+9zYZjPoM8btmBYON6lvqbxeBuIbdo/8gqO/0RPyGa0CvXYeBGQdlxuljenNOpj1Mir+/t5BQmcgxU363M5qYQYj+LoGj6jCOFur+7SBHWQD91/9U7ckWkVAN5XDnCHv0dEYCBnWFKsJTeRUarshtOFNcbDJK+0H6wum1PKJuPvWzuKmVj59vsnatewXs9zMpkoLxeDsUeqwKZIbwMlaK/i8e6HvvzTiPb85YgeRaRhiQadl/QiEyqMuwbXfQneQ== rsa-key-20200520"
}
resource "aws_instance" "wordpress" {
  ami = "ami-06fcc1f0bc2c8943f"
  credit_specification {
    cpu_credits = "standard"
  }
  instance_type          = "t3.small"
  key_name               = aws_key_pair.wordpress.key_name
  vpc_security_group_ids = [aws_security_group.wordpress.id]
  subnet_id              = tolist(data.aws_subnet_ids.public.ids)[0]
  root_block_device {
    volume_size = 8
  }
  tags = merge(
    { Name = "Application Wordpress" },
    var.default_tags
  )
  user_data = <<-EOF
curl https://wordpress.org/wordpress-4.9.5.tar.gz -o wordpress.tar.gz
wget https://github.com/aws-samples/eb-php-wordpress/releases/download/v1.1/eb-php-wordpress-v1.zip
tar -xvf wordpress.tar.gz
mv wordpress wordpress-beanstalk
cd wordpress-beanstalk
unzip ../eb-php-wordpress-v1.zip
  EOF
}
resource "aws_eip" "wordpress" {
  vpc      = true
  instance = aws_instance.wordpress.id
  tags = merge(
    { Name = "Application Wordpress" },
    var.default_tags
  )
}