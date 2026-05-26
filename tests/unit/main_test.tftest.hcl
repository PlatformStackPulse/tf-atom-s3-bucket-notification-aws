mock_provider "aws" {}

run "creates_notification_with_sqs" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    bucket_id   = "my-test-bucket"
    sqs_notifications = [{
      queue_arn = "arn:aws:sqs:eu-west-2:123456789012:my-queue"
      events    = ["s3:ObjectCreated:*"]
    }]
  }

  assert {
    condition     = output.id != null
    error_message = "id output should not be null when enabled"
  }
}

run "creates_nothing_when_disabled" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    enabled     = false
    bucket_id   = "my-test-bucket"
  }

  assert {
    condition     = length(aws_s3_bucket_notification.this) == 0
    error_message = "No resource should be created when disabled"
  }
}

run "supports_lambda_notifications" {
  variables {
    name        = "test"
    environment = "dev"
    namespace   = "unit"
    bucket_id   = "my-test-bucket"
    lambda_notifications = [{
      lambda_function_arn = "arn:aws:lambda:eu-west-2:123456789012:function:process-uploads"
      events              = ["s3:ObjectCreated:Put"]
      filter_suffix       = ".jpg"
    }]
  }

  assert {
    condition     = output.id != null
    error_message = "Should create notification config with Lambda"
  }
}
