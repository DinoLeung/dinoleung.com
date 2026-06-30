default:
	just --list

mod:
	go mod tidy

wasm:
	install -m 0644 "$(go env GOROOT)/lib/wasm/wasm_exec.js" web/wasm_exec.js
	GOOS=js GOARCH=wasm go build -o web/app.wasm ./src

static:
	rm -rf dist
	mkdir -p dist/web
	cp -R web/. dist/web/
	GOOS=js GOARCH=wasm go build -o dist/web/app.wasm ./src
	GENERATE_STATIC=1 STATIC_DIR=dist go run ./src

serve: wasm
	go run ./src

watch:
	watchexec --restart --exts go,css,webmanifest -- just serve

check: static
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
	aws s3 sync dist "s3://$(tofu -chdir=infra/opentofu output -raw site_bucket_name)" --delete
	aws cloudfront create-invalidation --distribution-id "$(tofu -chdir=infra/opentofu output -raw cloudfront_distribution_id)" --paths "/*"
