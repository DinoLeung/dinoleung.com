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
