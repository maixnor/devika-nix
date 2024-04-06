{ lib, stdenv, fetchFromGitHub, python3, uvicorn, playwright, bun, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "devika";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "stitionai";
    repo = "devika";
    rev = "edd99a7fd112173436f3b8e3bcdadb1e31a961eb"; # Use a specific commit or tag for reproducibility.
    sha256 = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"; # Update this with the correct hash.
  };

  buildInputs = [ python3 uvicorn playwright bun makeWrapper ];

  propagatedBuildInputs = [ python3.pkgs.uvloop python3.pkgs.pip ];

  postPatch = ''
    substituteInPlace requirements.txt --replace "uvicorn" ""
  '';

  postInstall = ''
    # Set up Python virtual environment and install dependencies
    ${python3}/bin/python3 -m venv $out/.venv
    source $out/.venv/bin/activate
    pip install -r requirements.txt

    # Install playwright dependencies
    playwright install --with-deps

    # Setup frontend
    pushd ui/
    bun install
    popd

    makeWrapper ${python3}/bin/python3 $out/bin/devika \
      --run "cd $out" \
      --run "source .venv/bin/activate" \
      --run "cd ui && bun run dev &" \
      --run "cd .." \
      --add-flags "devika.py"
  '';

  meta = with lib; {
    description = "Devika Application";
    homepage = "https://github.com/stitionai/devika";
    license = licenses.mit;
    maintainers = with maintainers; [ ]; # Add your maintainer name here.
  };
}

