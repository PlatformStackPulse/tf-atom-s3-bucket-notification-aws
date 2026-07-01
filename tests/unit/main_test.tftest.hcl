mock_provider "aws" {}

variables {
  namespace = "eg"
  stage     = "test"
  name      = "thing"
  bucket_id = "eg-test-thing-bucket"
  sqs_notifications = [{
    queue_arn = "arn:aws:sqs:eu-west-2:123456789012:my-queue"
    events    = ["s3:ObjectCreated:*"]
  }]
  lambda_notifications = [{
    lambda_function_arn = "arn:aws:lambda:eu-west-2:123456789012:function:process-uploads"
    events              = ["s3:ObjectCreated:Put"]
    filter_suffix       = ".jpg"
  }]
}

run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true when the module is enabled"
  }

  assert {
    condition     = length(aws_s3_bucket_notification.this) == 1
    error_message = "Exactly one aws_s3_bucket_notification resource should be planned when enabled"
  }

  assert {
    condition     = aws_s3_bucket_notification.this[0].bucket == "eg-test-thing-bucket"
    error_message = "bucket should pass through the bucket_id input"
  }
}

run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when the module is disabled"
  }

  assert {
    condition     = output.id == null
    error_message = "id output should be null when the module is disabled"
  }

  assert {
    condition     = length(aws_s3_bucket_notification.this) == 0
    error_message = "No aws_s3_bucket_notification resource should be planned when disabled"
  }
}
