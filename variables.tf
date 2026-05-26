variable "bucket_id" {
  description = "ID (name) of the S3 bucket to configure notifications for"
  type        = string
}

variable "lambda_notifications" {
  description = "List of Lambda function notification configurations"
  type = list(object({
    id                  = optional(string, null)
    lambda_function_arn = string
    events              = list(string)
    filter_prefix       = optional(string, null)
    filter_suffix       = optional(string, null)
  }))
  default = []
}

variable "sqs_notifications" {
  description = "List of SQS queue notification configurations"
  type = list(object({
    id            = optional(string, null)
    queue_arn     = string
    events        = list(string)
    filter_prefix = optional(string, null)
    filter_suffix = optional(string, null)
  }))
  default = []
}

variable "sns_notifications" {
  description = "List of SNS topic notification configurations"
  type = list(object({
    id            = optional(string, null)
    topic_arn     = string
    events        = list(string)
    filter_prefix = optional(string, null)
    filter_suffix = optional(string, null)
  }))
  default = []
}
