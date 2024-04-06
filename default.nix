{ lib, stdenv, fetchFromGitHub, python3, uv, playwright, bun }:

stdenv.mkDerivation rec {
  pname = "devika";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "stitionai";
    repo = "devika";
    rev = "eb09e2aacd25788430d289773b81b11ac52ac86d"; 
    sha256 = "sha256-Oowa9anYR7qvVtBBiH1kWgkc8bgJZN4j9aVvTxqHulY=";
  };

  buildInputs = [ python3 uv playwright bun ];

  postInstall = ''
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
  '';

  meta = with lib; {
    description = "Devika Application";
    homepage = "https://github.com/stitionai/devika";
    license = licenses.mit;
    maintainers = with maintainers; [ ]; # Add your maintainer name here.
  };
}

