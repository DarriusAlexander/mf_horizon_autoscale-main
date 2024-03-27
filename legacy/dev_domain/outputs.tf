# output.tf

# output "server-data" {
#   value = [for vm in aws_instance.dev_domain[*] : {
#     ip_address = vm.public_ip
#     public_dns = vm.public_dns
#   }]
#   description = "The public IP and DNS of the servers"
# }

output "ip_addr" {
  value       = aws_instance.dev_domain.public_ip
  description = "The public IP and DNS of the servers"
}

output "server-data-pub-dns" {
  value       = aws_instance.dev_domain.public_dns
  description = "The public IP and DNS of the servers"
}
