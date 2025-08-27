output "dns_name" {
  description = "The FQDN of the NLB instance"
  value       = aws_lb.this.dns_name
}

output "aws_lb_arn" {
  description = "The ARN of the NLB instance"
  value       = aws_lb.this.arn
}

output "aws_lb_listener_arns" {
  value = { for k, v in aws_lb_listener.this : k => v.arn }
}

output "aws_lb_target_group_arns" {
  value = { for k, v in aws_lb_target_group.this : k => v.arn }
}

output "aws_lb_security_group_id" {
  value = try(module.security_group[0].security_group_id, "N/A")
}
