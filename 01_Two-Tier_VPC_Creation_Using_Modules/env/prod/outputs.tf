output "nat_public_ip" {
  value       = module.vpc.nat_public_ip
  description = "Public IP address of the NAT Gateway in the Main VPC"
}