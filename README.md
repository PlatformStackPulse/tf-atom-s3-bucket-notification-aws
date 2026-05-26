# tf-atom-s3-bucket-notification-aws

[![CI](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-notification-aws/actions/workflows/ci.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-notification-aws/actions/workflows/ci.yml)
[![Release](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-notification-aws/actions/workflows/auto-release.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-notification-aws/actions/workflows/auto-release.yml)

---

## Purpose

Configures S3 event notifications to trigger Lambda functions, SQS queues, or SNS topics when objects are created, deleted, or modified. Supports prefix/suffix filtering for targeted event routing.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│           Molecule Layer                                        │
│  ┌──────────────┐    ┌──────────────────────────┐              │
│  │ s3-bucket    │───▶│ THIS MODULE              │              │
│  │ (bucket_id)  │    │ notification             │              │
│  └──────────────┘    └──────┬──────┬──────┬─────┘              │
│                             │      │      │                    │
│                             ▼      ▼      ▼                    │
│                      ┌──────┐ ┌────┐ ┌─────┐                  │
│                      │Lambda│ │SQS │ │ SNS │                  │
│                      └──────┘ └────┘ └─────┘                  │
└─────────────────────────────────────────────────────────────────┘
```

## Scope

| In Scope | Out of Scope |
|----------|--------------|
| `aws_s3_bucket_notification` resource | Bucket creation (→ `tf-atom-s3-bucket-aws`) |
| Lambda, SQS, SNS destinations | Lambda function creation |
| Prefix/suffix event filtering | SQS/SNS resource creation |
| Multiple notification rules | Lambda permissions (aws_lambda_permission) |

## Features

- **Single-resource atom** — one `aws_s3_bucket_notification`
- **Multi-destination** — Lambda, SQS, and SNS in one config
- **Event filtering** — prefix and suffix filters per destination
- **Dynamic blocks** — clean HCL for multiple notification rules
- **Tested** — unit tests for SQS, Lambda, and disabled scenarios

## Usage

```hcl
module "bucket_notification" {
  source = "github.com/PlatformStackPulse/tf-atom-s3-bucket-notification-aws?ref=v1.0.0"

  context   = module.this.context
  bucket_id = module.bucket.bucket_id

  sqs_notifications = [{
    queue_arn = module.queue.arn
    events    = ["s3:ObjectCreated:*"]
  }]

  lambda_notifications = [{
    lambda_function_arn = module.processor.arn
    events              = ["s3:ObjectCreated:Put"]
    filter_suffix       = ".csv"
  }]
}
```

## Module Documentation

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
