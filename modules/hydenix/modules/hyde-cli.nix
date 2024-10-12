{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.hyde-cli;
  hyde-cli = import ./sources/hyde-cli.nix { inherit pkgs lib; };

in
{
  options.modules.hyde-cli = {
    enable = lib.mkEnableOption "Hyde CLI tool";
  };

  config = lib.mkIf cfg.enable {
    home.activation = {
      # Due to nixos derivations not retaining .git folder, we need to create a stub meta file
      makeStubMeta = lib.hm.dag.entryAfter [ "mutableFileGeneration" ] ''
        mkdir -p $HOME/.cache/hyde
        $DRY_RUN_CMD cat << EOF > $HOME/.cache/hyde/hyde.meta
        #? This is a meta file generated for hyde-cli
        #! Do not touch this!
        #* Use 'chattr -i "\' to lift protection attributes   
        export CloneDir="/home/${config.home.username}/.local/hyprdots"
        export current_branch="master"
        export git_url="https://github.com/prasanthrangan/hyprdots.git"
        export restore_cfg_hash=""
        export git_hash=""
        export hyde_version="master"
        export modify_date=""
        export commit_message=""
        EOF
      '';
      hydeLink = lib.hm.dag.entryAfter [ "makeStubMeta" ] ''
        export PATH="${lib.makeBinPath hyde-cli.buildInputs}:$PATH"
        $DRY_RUN_CMD ${hyde-cli.pkg}/bin/Hyde-install -l -d $HOME/.local/hyprdots
      '';
    };

    home.file.".local/Hyde-cli" = {
      source = hyde-cli.src;
      recursive = true;
      mutable = true;
      force = true;
    };

    home.packages = [
      hyde-cli.pkg
    ];
  };
}
