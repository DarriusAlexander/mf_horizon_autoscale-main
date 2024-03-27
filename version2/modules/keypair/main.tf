
resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pemfile" {
  content  = tls_private_key.rsa.private_key_pem
  filename = var.filename
}

