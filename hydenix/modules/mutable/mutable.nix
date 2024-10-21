# This module extends home.file, xdg.configFile and xdg.dataFile with the `mutable` option.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  fileOptionAttrPaths = [
    [
      "home"
      "file"
    ]
    [
      "xdg"
      "configFile"
    ]
    [
      "xdg"
      "dataFile"
    ]
  ];
in
{
  options =
    let

      mergeAttrsList = builtins.foldl' (lib.mergeAttrs) { };

      fileAttrsType = lib.types.attrsOf (
        lib.types.submodule (
          { config, ... }:
          {
            options.mutable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether to copy the file without the read-only attribute instead of
                symlinking. If you set this to `true`, you must also set `force` to
                `true`. Mutable files are not removed when you remove them from your
                configuration.

                This option is useful for programs that don't have a very good
                support for read-only configurations.
              '';
            };
          }
        )
      );

    in
    mergeAttrsList (
      map (
        attrPath: lib.setAttrByPath attrPath (lib.mkOption { type = fileAttrsType; })
      ) fileOptionAttrPaths
    );

  config = {
    home.packages = with pkgs; [
      file
      findutils
    ];

    home.activation.mutableFileGeneration =
      let

        allFiles = (
          builtins.concatLists (
            map (attrPath: builtins.attrValues (lib.getAttrFromPath attrPath config)) fileOptionAttrPaths
          )
        );

        filterMutableFiles = builtins.filter (
          file:
          (file.mutable or false)
          && lib.assertMsg file.force "if you specify `mutable` to `true` on a file, you must also set `force` to `true`"
        );

        mutableFiles = filterMutableFiles allFiles;

        toCommand = (
          file:
          let
            source = lib.escapeShellArg file.source;
            target = lib.escapeShellArg file.target;
            recursiveFlag = if (file.recursive or false) then "-r" else "";
          in
          ''
            $VERBOSE_ECHO "Copying mutable file: ${source} -> ${target}"
            if [ ${recursiveFlag} != "" ]; then
              $DRY_RUN_CMD cp -r --remove-destination --no-preserve=mode ${source}/. ${target}
            else
              $DRY_RUN_CMD cp --remove-destination --no-preserve=mode ${source} ${target}
            fi

            $DRY_RUN_CMD chmod -R u+w ${target}

            # Check if the file is a script or binary before making it executable
            if [ -d ${target} ]; then
              find ${target} -type f -print0 | xargs -0 -I {} sh -c '
                if ${pkgs.file}/bin/file -b "{}" | grep -qE "executable|script" || [[ "{}" == *.sh ]]; then
                  $DRY_RUN_CMD chmod u+wx "{}"
                fi
              '
            else
              if ${pkgs.file}/bin/file -b ${target} | grep -qE "executable|script" || [[ ${target} == *.sh ]]; then
                $DRY_RUN_CMD chmod u+wx ${target}
              fi
            fi
          ''
        );

        command =
          ''
            export PATH="${pkgs.file}/bin:${pkgs.findutils}/bin:$PATH"
            echo "Copying mutable home files for $HOME"
          ''
          + lib.concatLines (map toCommand mutableFiles);

      in
      (lib.hm.dag.entryAfter [ "linkGeneration" ] command);
  };
}
