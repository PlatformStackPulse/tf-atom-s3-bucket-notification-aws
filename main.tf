# -----------------------------------------------------
# Atom: S3 Bucket Notification
# Configures event notifications for an S3 bucket.
# -----------------------------------------------------
resource "aws_s3_bucket_notification" "this" {
  count = module.this.enabled ? 1 : 0

  bucket = var.bucket_id

  dynamic "lambda_function" {
    for_each = var.lambda_notifications
    content {
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
      id                  = lambda_function.value.id
    }
  }

  dynamic "queue" {
    for_each = var.sqs_notifications
    content {
      queue_arn     = queue.value.queue_arn
      events        = queue.value.events
      filter_prefix = queue.value.filter_prefix
      filter_suffix = queue.value.filter_suffix
      id            = queue.value.id
    }
  }

  dynamic "topic" {
    for_each = var.sns_notifications
    content {
      topic_arn     = topic.value.topic_arn
      events        = topic.value.events
      filter_prefix = topic.value.filter_prefix
      filter_suffix = topic.value.filter_suffix
      id            = topic.value.id
    }
  }
}
