# inventory.tf

# resource "local_sensitive_file" "private_key" {
#   content         = aws_instance.dev_main.key_name
#   filename        = format("%s/%s/%s", abspath(path.root), ".ssh", "ops_marinerfinance.pem")
#   file_permission = "0600"
# }

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl", {
    ip_addr = aws_instance.dev_domain.public_ip
    # ip_addrs = [for i in aws_instance.dev_domain : i.public_ip]
    # ssh_keyfile = local_sensitive_file.private_key.filename
  })
  filename = format("%s/%s", abspath(path.root), "inventory.ini")
}
