output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.bpzb.dns_name
}

output "zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = aws_lb.bpzb.zone_id
}
