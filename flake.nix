
{
  description = "A development shell for running devika";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
			dependencies = {};
    in {
      packages.devika = pkgs.callPackage ./default.nix { };

      defaultPackage = self.packages.devika;

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        # ollama implied
        buildInputs = with pkgs; [
          python3
          uv
          playwright
          bun
          #self.packages.devika
        ];
        shellHook = ''
          cd devika/
          uv venv
          source .venv/bin/activate
          uv pip install -r requirements.txt
          playwright install --with-deps
          cd ui/
          bun install
          bun run dev &
          cd ..
          python3 devika.py
          exit
        '';
      };
    });
}


