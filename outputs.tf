output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}

output "id" {
  description = "ID of the notification configuration"
  value       = try(aws_s3_bucket_notification.this[0].id, null)
}
