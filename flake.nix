
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
        nativeBuildInputs = with pkgs; [ bashInteractive playwright-driver.browsers ];
        # ollama implied
        buildInputs = with pkgs; [
          python3
          uv
          playwright
          bun
          #self.packages.devika

          # dev dependencies
          dotnet-sdk_8
          dotnet-aspnetcore_8
          dotnet-runtime_8
          dotnetPackages.SharpZipLib
        ];
        shellHook = ''
          cd devika/
          uv venv
          source .venv/bin/activate
          uv pip install -r requirements.txt
          export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
          export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
          cd ui/
          bun install
          bun run dev &
          cd ..
          python3 devika.py
        '';
      };
    });
}


