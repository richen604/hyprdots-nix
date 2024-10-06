# This module extends home.file, xdg.configFile and xdg.dataFile with the `mutable` option.
{ config, lib, ... }:
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
            recursiveFlag = if (file.recursive or false) then "-R" else "";
          in
          ''
            $VERBOSE_ECHO "${source} -> ${target}"
            if [ -d ${source} ]; then
              $DRY_RUN_CMD mkdir -p ${target}
              $DRY_RUN_CMD cp ${recursiveFlag} --remove-destination --preserve=mode ${source}/. ${target}/
            else
              $DRY_RUN_CMD cp ${recursiveFlag} --remove-destination --preserve=mode ${source} ${target}
            fi
            $DRY_RUN_CMD chmod -R u+rwX,go+rX,go-w ${target}
            $DRY_RUN_CMD chown -R $USER:users ${target}
          ''
        );

        command =
          ''
            echo "Copying mutable home files for $HOME"
          ''
          + lib.concatLines (map toCommand mutableFiles);

      in
      (lib.hm.dag.entryAfter [ "linkGeneration" ] command);
  };
}
