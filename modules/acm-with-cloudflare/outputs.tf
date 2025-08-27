output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = try(aws_acm_certificate_validation.this.certificate_arn, aws_acm_certificate.this.arn, "N/A")
}

output "acm_certificate_status" {
  description = "Status of the certificate."
  value       = try(aws_acm_certificate.this.status, "N/A")
}

output "registered_domains" {
  description = "The domains registered in the certificate"
  value       = [for k, v in aws_acm_certificate.this.domain_validation_options : v.domain_name]
}
