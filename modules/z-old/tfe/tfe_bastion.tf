resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAhWyC88zOQupw7jIbASm5g3fBRggAMWvL8zU4TN7aI3B92FaJVQeENdhY/V/9URh9/1AOc4NjbFy9JpIXRavYJi+9zYZjPoM8btmBYON6lvqbxeBuIbdo/8gqO/0RPyGa0CvXYeBGQdlxuljenNOpj1Mir+/t5BQmcgxU363M5qYQYj+LoGj6jCOFur+7SBHWQD91/9U7ckWkVAN5XDnCHv0dEYCBnWFKsJTeRUarshtOFNcbDJK+0H6wum1PKJuPvWzuKmVj59vsnatewXs9zMpkoLxeDsUeqwKZIbwMlaK/i8e6HvvzTiPb85YgeRaRhiQadl/QiEyqMuwbXfQneQ== rsa-key-20200520"
}
resource "aws_instance" "bastion" {
  ami = "ami-06fcc1f0bc2c8943f"
  credit_specification {
    cpu_credits = "standard"
  }
  instance_type          = "t3.small"
  key_name               = aws_key_pair.bastion.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = var.alb_subnet_ids[0]
  root_block_device {
    volume_size = 8
  }
  tags = merge(
    { Name = "TFE Bastion" },
    var.common_tags
  )
  user_data = <<-EOF
sudo yum update -y
  EOF
}

resource "aws_eip" "bastion" {
  vpc      = true
  instance = aws_instance.bastion.id
  tags = merge(
    { Name = "TFE Bastion" },
    var.common_tags
  )
}
resource "aws_security_group" "bastion" {
  name   = "TFE Bastion"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
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
    { Name = "TFE Bastion" },
    var.common_tags
  )
}