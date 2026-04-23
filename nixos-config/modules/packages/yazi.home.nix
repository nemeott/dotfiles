{ pkgs, ... }:

{
  programs.yazi = {
    enable = true; # Terminal-based file explorer
    extraPackages = with pkgs; [
      trash-cli # Used by recycle-bin plugin
      jdupes # Used by dupes plugin
    ];
    plugins = with pkgs; {
      inherit (yaziPlugins)
        smart-paste
        git
        diff
        chmod
        mount
        recycle-bin
        rsync
        compress
        dupes
        toggle-pane
        # mediainfo # TODO: mediainfo
        lazygit
        ;
      # TODO: Fix zoom plugin (or add it to nixpkgs)
      zoom = yaziPlugins.mkYaziPlugin {
        pname = "zoom.yazi";
        version = "2026-03-08";
        src = fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "196281844b8cbcac658a59013e4805300c2d6126";
          hash = "sha256-pAkBlodci4Yf+CTjhGuNtgLOTMNquty7xP0/HSeoLzE=";
        };
      };
    };
    initLua = ''
          				-- Git plugin configuration
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
                  
          				-- Recycle bin plugin configuration
                  require("recycle-bin"):setup()
                  
          				-- Dupes plugin configuration
                  th.dupes = th.dupes or {}
                  -- th.dupes.mark_style = ui.Style():fg("#FFFFFF")
                  th.dupes.mark_style = ui.Style():fg("blue")
                  th.dupes.mark_sign = "X"
                  
                  require("dupes"):setup {
      							-- Global settings
      							save_op = false,        -- Save results to file by default
      							-- auto_confirm = true, -- Skip confirmation for apply (use with caution!)
      							
      							profiles = {
      								-- Interactive mode: recursively scan and display duplicates
      								interactive = {
      									args = { "-r" },
      								},
      								-- Apply mode: recursively scan and DELETE duplicates
      								apply = {
      									args = { "-r", "-N", "-d" },
      									save_op = true,  -- Save results before deletion
      								},
      								-- Custom profile example (uncomment to use)
      								-- custom = {
      								-- 	args = { "-r", "-s", },  -- Your custom jdupes flags
      								-- },
      							},
                  }
                  
          				-- Size and time display configuration
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
        #
        # General
        #

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
        {
          on = "<A-Left>";
          run = "back";
          desc = "Back to previous directory";
        }
        {
          on = "<A-Right>";
          run = "forward";
          desc = "Forward to next directory";
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
        {
          on = "<C-Tab>";
          run = "tab_switch 1 --relative";
          desc = "Switch to next tab";
        }
        {
          on = "<C-BackTab>";
          run = "tab_switch -1 --relative";
          desc = "Switch to previous tab";
        }
        # Go to directory
        {
          on = [
            "g"
            "C"
          ];
          run = "cd ~/Coding";
          desc = "Go ~/Coding";
        }
        {
          on = [
            "g"
            "D"
          ];
          run = "cd ~/Documents";
          desc = "Go ~/Documents";
        }
        {
          on = [
            "g"
            "."
          ];
          run = "cd ~/dotfiles";
          desc = "Go ~/dotfiles";
        }

        #
        # Plugins
        #

        # Smart paste plugin
        {
          on = "p";
          run = "plugin smart-paste";
          desc = "Paste into the hovered directory or CWD";
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

        # Mount plugin
        {
          on = "M";
          run = "plugin mount";
          desc = "Open mount plugin menu";
        }

        # Recycle bin plugin
        {
          on = [
            "R"
            "b"
          ];
          run = "plugin recycle-bin";
          desc = "Open Recycle Bin menu";
        }

        # Rsync plugin
        {
          on = [
            "R"
            "s"
          ];
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

        # FIXME: Zoom plugin
        {
          on = "+";
          run = "plugin zoom 1";
          desc = "Zoom in hovered file";
        }
        {
          on = "-";
          run = "plugin zoom -1";
          desc = "Zoom out hovered file";
        }

        # Dupes plugin
        {
          on = [
            "j"
            "i"
          ];
          run = "plugin dupes interactive";
          desc = "Display duplicates";
        }
        {
          on = [
            "j"
            "d"
          ];
          run = "plugin dupes dry";
          desc = "Preview apply mode";
        }
        {
          on = [
            "j"
            "a"
          ];
          run = "plugin dupes apply";
          desc = "Permanently delete duplicates";
        }
        {
          on = [
            "j"
            "o"
          ];
          run = "plugin dupes override";
          desc = "Custom jdupes args";
        }

        # LazyGit plugin
        {
          on = [
            "l"
            "g"
          ];
          run = "plugin lazygit";
          desc = "Open LazyGit in current directory";
        }
      ];
    };
    settings = {
      mgr = {
        sort_by = "mtime";
        sort_reverse = true; # Newest first
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
}
