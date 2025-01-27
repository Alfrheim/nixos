{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {enable = mkEnableOption "hyprland";};
  config = mkIf cfg.enable {
    programs.hyprlock.enable = true;
    wayland.windowManager.hyprland = {
      #https://github.com/vimjoyer/nixconf/blob/8bdeb4a3119adda168e6fb489a5e380d8eed91de/homeManagerModules/features/hyprland/default.nix#L17
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      settings = {
        # monitor = "X11-1,3840x2160@60,0x0,1";
        monitor = "DP-1,3840x2160@60,0x0,1";

        exec-once = [
          "swaybg -i ~/.wallpaper"
          "waybar"
          "nm-applet --indicator"
          "dunst"
          "lxqt.lxqt-policykit"
        ];

        env = [
          "XCURSOR_SIZE,24"
          # "GDK_BACKEND,wayland,x11"
          # "SDL_VIDEODRIVER,wayland"
          # "CLUTTER_BACKEND,wayland"
          # "MOZ_ENABLE_WAYLAND,1"
          # "MOZ_DISABLE_RDD_SANDBOX,1"
          # "_JAVA_AWT_WM_NONREPARENTING=1"
          # "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          # "QT_QPA_PLATFORM,wayland"
          # "LIBVA_DRIVER_NAME,nvidia"
          # "GBM_BACKEND,nvidia-drm"
          # "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          # "WLR_NO_HARDWARE_CURSORS,1"
          # "__NV_PRIME_RENDER_OFFLOAD,1"
          # "__VK_LAYER_NV_optimus,NVIDIA_only"
          # "PROTON_ENABLE_NGX_UPDATER,1"
          # "NVD_BACKEND,direct"
          # "__GL_GSYNC_ALLOWED,1"
          # "__GL_VRR_ALLOWED,1"
          # "WLR_DRM_NO_ATOMIC,1"
          # "WLR_USE_LIBINPUT,1"
          # "XWAYLAND_NO_GLAMOR,1"
          # "__GL_MaxFramesAllowed,1"
          # "WLR_RENDERER_ALLOW_SOFTWARE,1"
        ];

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";

          kb_rules = "";

          follow_mouse = 1;

          touchpad = {
            natural_scroll = false;
          };
          float_switch_override_focus = 0;
          mouse_refocus = 1;
          numlock_by_default = true;

          # repeat_rate = 40;
          # repeat_delay = 250;
          # force_no_accel = true;

          sensitivity = 0.0; # -1.0 - 1.0, 0 means no modification.
        };
        general = {
          gaps_in = 8;
          gaps_out = 20;
          border_size = 4;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";
          # layout = master

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
        };
        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = 20;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        "$mainMod" = "SUPER";

        bindl = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];

        animations = {
          enabled = "yes";
          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_status = "master";
          # soon :)
          # orientation = "center";
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = false;
        };
      };

      extraConfig = ''


        # monitor=X11-1,3840x2160@60,0x0,1

        #exec=QT_QPA_PLATFORM=xcb Enpass -minimize
        # exec-once=hyprdim -s 0.6 --persist --no-dim-when-only # darken windows that are not focused
        # exec-once=nwg-dock-hyprland


        #######################################################################################
        #AUTOGENERATED HYPR CONFIG.
        #PLEASE USE THE CONFIG PROVIDED IN THE GIT REPO /examples/hypr.conf AND EDIT IT,
        #OR EDIT THIS ONE ACCORDING TO THE WIKI INSTRUCTIONS.
        ########################################################################################

        #
        # Please note not all available settings / options are set here.
        # For a full list, see the wiki
        #

        # autogenerated = 1 # remove this line to remove the warning

        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor=,preferred,auto,auto


        # See https://wiki.hyprland.org/Configuring/Keywords/ for more

        # Execute your favorite apps at launch
        # exec-once = waybar & hyprpaper & firefox

        # Source a file (multi-file configs)
        # source = ~/.config/hypr/myColors.conf


        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/

        misc {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            force_default_wallpaper = -1 # Set to 0 to disable the anime mascot wallpapers
            animate_manual_resizes = true
        }

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
        #device:epic-mouse-v1 {
        #    sensitivity = -0.5
        #}

        # Example windowrule v1
        # windowrule = float, ^(kitty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

        ####   https://github.com/hyprwm/Hyprland/issues/3450
        # -- Fix odd behaviors in IntelliJ IDEs --
        #! Fix focus issues when dialogs are opened or closed
        #windowrulev2 = windowdance,class:^(jetbrains-.*)$,floating:1
        #! Fix splash screen showing in weird places and prevent annoying focus takeovers
        windowrulev2 = center,class:^(jetbrains-.*)$,title:^(splash)$,floating:1
        windowrulev2 = nofocus,class:^(jetbrains-.*)$,title:^(splash)$,floating:1
        windowrulev2 = noborder,class:^(jetbrains-.*)$,title:^(splash)$,floating:1

        #! Center popups/find windows
        windowrulev2 = center,class:^(jetbrains-.*)$,title:^( )$,floating:1
        windowrulev2 = stayfocused,class:^(jetbrains-.*)$,title:^( )$,floating:1
        windowrulev2 = noborder,class:^(jetbrains-.*)$,title:^( )$,floating:1
        #! Disable window flicker when autocomplete or tooltips appear
        windowrulev2 = nofocus,class:^(jetbrains-.*)$,title:^(win.*)$,floating:1
        windowrulev2 = opacity 0.80 0.80,class:^(Spotify)$
        windowrulev2 = opacity 0.90 0.90,class:^(discord)$ #Discord-Electron

        windowrulev2 = float,class:^(pavucontrol)$
        windowrulev2 = float,class:^(blueman-manager)$
        windowrulev2 = float,class:^(nm-applet)$
        windowrulev2 = float,class:^(Enpass)$
        windowrulev2 = float,class:^(nm-connection-editor)$
        windowrulev2 = float,class:^(org.kde.polkit-kde-authentication-agent-1)$
        windowrulev2 = float,class:^(polkit-gnome-authentication-agent-1)$

        # windowrulev2 = workspace 9,class:^(Enpass)$



        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, Q, exec, warp-terminal
        bind = $mainMod, C, killactive,
        bind = $mainMod_SHIFT, Q, killactive,
        bind = $mainMod, X, exit,
        bind = $mainMod, E, exec, dolphin
        bind = $mainMod, F, togglefloating,
        bind = $mainMod SHIFT, F, fullscreen,
        bind = $mainMod, R, exec, wofi --show drun
        bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, J, togglesplit, # dwindle
        bind = SUPER_ALT, R, exec, wofi --show run --xoffset=1670 --yoffset=12 --width=230px --height=984 --style=$HOME/.config/wofi.css --term=footclient --prompt=Run
        bind=SUPER, Space, exec, wezterm
        bind= $mainMod, D, exec, launcher window & sleep 0.2; hyprctl dispatch focuswindow "^(Rofi)"
        bind= $mainMod, B, exec, launcher drun & sleep 0.2; hyprctl dispatch focuswindow "^(Rofi)"
        bind = $mainMod SHIFT, J, exec, grim -g "$(slurp -d)" - | wl-copy


        # Move focus with mainMod + arrow keys
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d

        # Move focus with mainMod + arrow keys
        bind = $mainMod Control_L, 4, resizeactive , -50 0
        bind = $mainMod Control_L, 6, resizeactive , 50 0
        bind = $mainMod Control_L, 8, resizeactive , 0 -50
        bind = $mainMod Control_L, 5, resizeactive , 0 50

        # Move focus with mainMod + arrow keys
        bind = SUPER_SHIFT, left, movewindow, l
        bind = SUPER_SHIFT, right, movewindow, r
        bind = SUPER_SHIFT, up, movewindow, u
        bind = SUPER_SHIFT, down, movewindow, d

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        # Example special workspace (scratchpad)
        bind = $mainMod, S, togglespecialworkspace, magic
        bind = $mainMod SHIFT, S, movetoworkspace, special:magic

        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow
      '';
    };
    home.packages = with pkgs; [
      lxqt.lxqt-policykit
      wofi
      swaybg
      wlsunset
      wl-clipboard
      swaylock
      swayidle
      wdisplays
      tofi
      waybar
      wmctrl
      hyprdim
      nwg-dock-hyprland
      wlr-randr
      wlogout
    ];

    # home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  };
}
