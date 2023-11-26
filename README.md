# terraform-using-localstack

## Start Localstack

> docker-compose up -d

## Add AWS Profile Localstack

By default, this file is at `~/.aws/config`

```
[profile localstack]
region = us-east-1
output = json
endpoint_url=http://localhost:4566
```

## Configude AWS CLI to use Localstack

> aws configure --profile localstack

## Run a AWS Command

>  aws --endpoint-url=http://localhost:4566 s3api list-buckets

Or

> aws --profile localstack s3api list-buckets

## AWS

### EC2 Instance

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance?product_intent=terraform#example-usage

### S3 

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#example-usage

## 