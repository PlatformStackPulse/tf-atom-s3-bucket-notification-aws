provider "aws" {
  region = "eu-west-2"
}

module "s3_notification" {
  source = "../../"

  namespace   = "psp"
  environment = "dev"
  name        = "assets"

  bucket_id = "psp-dev-assets"

  sqs_notifications = [{
    queue_arn = "arn:aws:sqs:eu-west-2:123456789012:upload-processor"
    events    = ["s3:ObjectCreated:*"]
  }]

  lambda_notifications = [{
    lambda_function_arn = "arn:aws:lambda:eu-west-2:123456789012:function:thumbnail-generator"
    events              = ["s3:ObjectCreated:Put"]
    filter_suffix       = ".jpg"
  }]
}

output "id" {
  value = module.s3_notification.id
}
