
{
  description = "A development shell for running devika";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
			dependencies = {};
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = with pkgs; [ 
          bun
          uv
          playwright
          python3
				];
  			shellHook = ''
          git clone https://github.com/stitionai/devika.git
          cd devika/
          uv venv
          source .venv/bin/activate
          uv pip install -r requirements.txt
          playwright install --with-deps
          cd ui/
          bun install
          bun run dev
          cd ..
          python3 devika.py
          $SHELL
          exit
        '';
       };


    });
}
