default:
	just --list

mod:
	go mod tidy

wasm:
	install -m 0644 "$(tinygo env TINYGOROOT)/targets/wasm_exec.js" web/wasm_exec.js
	tinygo build -target wasm -o web/app.wasm ./cmd/site

serve: wasm
	go run ./cmd/site

watch:
	watchexec --restart --exts go,css,webmanifest -- just serve

check: wasm
	go test ./...
