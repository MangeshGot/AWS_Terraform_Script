output "vpc_id" {
  value       = aws_vpc.main_vpc.id
  description = "ID of the Main VPC"  
}