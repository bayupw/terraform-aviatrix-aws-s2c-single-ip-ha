output "csr_public_ip" {
  description = "CSR Public IP."
  value       = module.csr1k.csr_instance.public_ip
}