resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl", {
    ip_addr = aws_instance.qa_domain.public_ip
    # ip_addrs = [for i in aws_instance.dev_domain : i.public_ip]
    # ssh_keyfile = local_sensitive_file.private_key.filename
  })
  filename = format("%s/%s", abspath(path.root), "inventory.ini")
}
