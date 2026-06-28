{
	description = "Development shell for a go-app application with TinyGo";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { nixpkgs, flake-utils, ... }:
		flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = import nixpkgs { inherit system; };
			in
			{
				devShells.default = pkgs.mkShell {
					packages = with pkgs; [
						go_1_25
						gopls
						gotools
						go-tools
						tinygo
						just
						watchexec
					];

					env = {
						GO111MODULE = "on";
						GOPROXY = "https://proxy.golang.org,direct";
					};

					shellHook = ''
						echo "go-app dev shell: go $(go version | awk '{print $3}'), tinygo $(tinygo version | awk '{print $3}')"
					'';
				};
			});
}
