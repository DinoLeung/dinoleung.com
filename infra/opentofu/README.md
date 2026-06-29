# OpenTofu Infrastructure

This stack provisions the AWS hosting resources for `dinoleung.com`:

- private S3 bucket for built static assets
- S3 public access block, ownership controls, versioning, encryption, and lifecycle rules
- CloudFront distribution with Origin Access Control
- security response headers
- optional ACM certificate and Route 53 alias records
- optional IAM deploy policy for CI or local deploy credentials

## Usage

```sh
cp infra/opentofu/terraform.tfvars.example infra/opentofu/terraform.tfvars
$EDITOR infra/opentofu/terraform.tfvars

tofu -chdir=infra/opentofu init -reconfigure
tofu -chdir=infra/opentofu plan
tofu -chdir=infra/opentofu apply
```

## Deploy Site Assets

Build the WASM app, sync `web/` to S3, then invalidate CloudFront:

```sh
just check
aws s3 sync web "s3://$(tofu -chdir=infra/opentofu output -raw site_bucket_name)" --delete
aws cloudfront create-invalidation \
  --distribution-id "$(tofu -chdir=infra/opentofu output -raw cloudfront_distribution_id)" \
  --paths "/*"
```

The S3 bucket is intentionally private. Public reads go through CloudFront only.
