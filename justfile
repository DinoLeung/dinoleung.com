default:
	just --list

mod:
	go mod tidy

wasm:
	install -m 0644 "$(go env GOROOT)/lib/wasm/wasm_exec.js" web/wasm_exec.js
	GOOS=js GOARCH=wasm go build -o web/app.wasm ./cmd/site

serve: wasm
	go run ./cmd/site

watch:
	watchexec --restart --exts go,css,webmanifest -- just serve

check: wasm
	go test ./...

infra-fmt:
	tofu -chdir=infra/opentofu fmt -recursive

infra-init:
	tofu -chdir=infra/opentofu init -reconfigure

infra-plan:
	tofu -chdir=infra/opentofu plan

infra-apply:
	tofu -chdir=infra/opentofu apply

deploy: check
	aws s3 sync web "s3://$(tofu -chdir=infra/opentofu output -raw site_bucket_name)" --delete
	aws cloudfront create-invalidation --distribution-id "$(tofu -chdir=infra/opentofu output -raw cloudfront_distribution_id)" --paths "/*"
