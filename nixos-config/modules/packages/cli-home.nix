{ pkgs, ... }:

{
  # Enabled here for automatic Catppuccin integration
  programs = {
    # shell history
    atuin = {
      enable = true;
      settings = {
        enter_accept = true; # Enter executes command immediately
        history_filter = [
          "^clear$"
          "^ls$"
          "^bash$"
        ];
      };
    };
    bat.enable = true; # cat
    btop.enable = true; # top
    eza.enable = true; # ls
    fzf.enable = true; # fuzzy finder

    yazi = {
      enable = true; # Terminal-based file explorer
      plugins = with pkgs; {
        git = yaziPlugins.git;
        diff = yaziPlugins.diff;
        chmod = yaziPlugins.chmod;
        rsync = yaziPlugins.rsync;
        compress = yaziPlugins.compress;
        toggle-pane = yaziPlugins.toggle-pane;
        # zoom = yaziPlugins.zoom;
      };
      initLua = ''
              -- https://github.com/yazi-rs/plugins/tree/main/git.yazi
              th.git = th.git or {}
              th.git = {
             	added_sign = "A",
             	modified_sign = "M",
             	deleted_sign = "D",
             	updated_sign = "U",
             	untracked_sign = "?",
             	ignored_sign = "i",
             	clean_sign = " ",
             	unknown_sign = " ",
              }
              
              require("git"):setup {
               	-- Order of status signs showing in the linemode
               	order = 1500,
              }
              
              function Linemode:size_and_mtime()
        			local time = math.floor(self._file.cha.mtime or 0)
        			if time == 0 then
        				time = ""
        			elseif os.date("%Y", time) == os.date("%Y") then
        				time = os.date("%b %d %H:%M", time)
        			else
        				time = os.date("%b %d  %Y", time)
        			end
        		         
        			local size = self._file:size()
        			return string.format("%s %s", size and ya.readable_size(size) or "-", time)
            end
      '';
      keymap = {
        mgr.prepend_keymap = [
          # Movement
          {
            on = "<S-Up>";
            run = "arrow -5";
            desc = "Move up 5 files";
          }
          {
            on = "<S-Down>";
            run = "arrow +5";
            desc = "Move down 5 files";
          }
          # Tabs
          {
            on = "<C-t>";
            run = "tab_create";
            desc = "Open new tab";
          }
          {
            on = "<C-w>";
            run = "close";
            desc = "Close current tab";
          }

          # Diff plugin
          {
            on = "<C-d>";
            run = "plugin diff";
            desc = "Copy diff selected w/ hovered file";
          }
          # Chmod plugin
          {
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Chmod selected files";
          }
          # Rsync plugin
          {
            on = "R";
            run = "plugin rsync";
            desc = "Copy files using rsync";
          }
          # Compress plugin
          {
            on = [
              "c"
              "a"
              "a"
            ];
            run = "plugin compress";
            desc = "Archive selected files";
          }
          {
            on = [
              "c"
              "a"
              "p"
            ];
            run = "plugin compress -p";
            desc = "Archive selected files (password)";
          }
          {
            on = [
              "c"
              "a"
              "h"
            ];
            run = "plugin compress -ph";
            desc = "Archive selected files (password+header)";
          }
          {
            on = [
              "c"
              "a"
              "l"
            ];
            run = "plugin compress -l";
            desc = "Archive selected files (compression level)";
          }
          {
            on = [
              "c"
              "a"
              "u"
            ];
            run = "plugin compress -phl";
            desc = "Archive selected files (password+header+level)";
          }
          # Toggle pane plugin
          {
            desc = "Minimize or restore the preview pane";
            on = "t";
            run = "plugin toggle-pane min-preview";
          }
          {
            desc = "Maximize or restore the preview pane";
            on = "T";
            run = "plugin toggle-pane max-preview";
          }
          # # Zoom plugin
          # {
          #   on = "+";
          #   run = "plugin zoom 1";
          #   desc = "Zoom in hovered file";
          # }
          # {
          #   on = "-";
          #   run = "plugin zoom -1";
          #   desc = "Zoom out hovered file";
          # }
        ];
      };
      settings = {
        mgr = {
          linemode = "size_and_mtime";
          show_hidden = true;
        };
        plugin.prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
          }
        ];
      };
    };
  };
}
