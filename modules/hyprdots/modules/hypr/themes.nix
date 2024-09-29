{

  decoration = {
    dim_special = 0.3;
  };

  general = {
    gaps_in = 3;
    gaps_out = 8;
    border_size = 2;
    layout = "dwindle";
    resize_on_border = true;
  };

  decoration = {
    rounding = 10;
    drop_shadow = false;

    blur = {
      enabled = true;
      size = 6;
      passes = 3;
      new_optimizations = "on";
      ignore_opacity = true;
      xray = false;
    };
  };

  # TODO: full nixify themes: some themes don't require waybar blur. allow extending
  layerrule = [
    "blur,waybar"
  ];
}
