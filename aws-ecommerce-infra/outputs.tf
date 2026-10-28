
output "application_url" {
  description = "Public HTTPS application URL"
  value       = "https://${local.app_hostname}"
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_arn" {
  value = aws_lb.main.arn
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "instance_ids" {
  value = aws_instance.app[*].id
}

output "instance_private_ips" {
  value = aws_instance.app[*].private_ip
}

output "target_group_arns" {
  value = local.all_target_group_arns
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.shop.arn
}

output "route53_nameservers" {
  description = "Set these at the domain registrar for a newly created zone"
  value       = aws_route53_zone.public[0].name_servers
}
