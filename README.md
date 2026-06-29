# dinoleung.com

A go-app application compiled to WebAssembly with TinyGo.

## Development

```sh
direnv allow
just mod
just serve
```

Open <http://localhost:8080>.

## Commands

```sh
just wasm
just serve
just watch
just check
```

## Infrastructure

OpenTofu configuration lives in `infra/opentofu`.

```sh
just infra-init
just infra-plan
just infra-apply
just deploy
```
