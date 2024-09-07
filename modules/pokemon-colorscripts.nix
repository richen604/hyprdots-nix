{
  lib,
  stdenv,
  fetchFromGitLab,
  bash,
  python3,
}:

stdenv.mkDerivation {
  pname = "pokemon-colorscripts";
  version = "main";

  src = fetchFromGitLab {
    owner = "phoneybadger";
    repo = "pokemon-colorscripts";
    rev = "0483c85b93362637bdd0632056ff986c07f30868";
    sha256 = "sha256-rj0qKYHCu9SyNsj1PZn1g7arjcHuIDGHwubZg/yJt7A=";
  };

  buildInputs = [
    bash
    python3
  ];

  installPhase = ''
    mkdir -p $out/opt/pokemon-colorscripts
    mkdir -p $out/bin

    cp -r colorscripts $out/opt/pokemon-colorscripts
    cp pokemon-colorscripts.py $out/opt/pokemon-colorscripts
    cp pokemon.json $out/opt/pokemon-colorscripts

    ln -s $out/opt/pokemon-colorscripts/pokemon-colorscripts.py $out/bin/pokemon-colorscripts
    chmod +x $out/bin/pokemon-colorscripts
  '';

  meta = with lib; {
    description = "CLI utility to print out images of pokemon to terminal";
    homepage = "https://gitlab.com/phoneybadger/pokemon-colorscripts";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "pokemon-colorscripts";
  };
}
