{ pkgs, ... }:

{
  programs.yazi = {
    enable = true; # Terminal-based file explorer
    extraPackages = with pkgs; [
      trash-cli # Used by recycle-bin plugin
      ouch
      imagemagick # Used by convert plugin
      # duckdb # TODO
      libreoffice-fresh # Used by office plugin
      poppler-utils # Used by office plugin (pdftoppm)
      jdupes # Used by dupes plugin
    ];
    plugins = {
      inherit (pkgs.yaziPlugins)
        close-and-restore-tab
        smart-paste
        jump-to-char
        git
        diff
        chmod
        mount
        recycle-bin
        rsync
        compress
        convert # Convert images to PNG, JPG, and WepP using ImageMagick
        ouch # Preview more archive types (like tar.zst)
        # duckdb # TODO
        office
        dupes # Detect and remove duplicates
        toggle-pane # Toggle the file finder or the preview pane
        # mediainfo # TODO
        lazygit
        ;
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
    settings = {
      mgr = {
        sort_by = "mtime";
        sort_reverse = true; # Newest first
        linemode = "size_and_mtime";
        show_hidden = true;
      };
      plugin = {
        prepend_fetchers = [
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
        prepend_previewers = [
          # Ouch plugin
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch --archive-icon=''"; # No icons
          }

          # Office plugin
          {
            mime = "application/openxmlformats-officedocument.*";
            run = "office";
          }
          {
            mime = "application/oasis.opendocument.*";
            run = "office";
          }
          {
            mime = "application/ms-*";
            run = "office";
          }
          {
            mime = "application/msword";
            run = "office";
          }
          {
            name = "*.docx";
            run = "office";
          }
        ];
        prepend_preloaders = [
          # Office plugin
          {
            mime = "application/openxmlformats-officedocument.*";
            run = "office";
          }
          {
            mime = "application/oasis.opendocument.*";
            run = "office";
          }
          {
            mime = "application/ms-*";
            run = "office";
          }
          {
            mime = "application/msword";
            run = "office";
          }
          {
            name = "*.docx";
            run = "office";
          }
        ];
      };
    };
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
        # {
        #   on = "<C-w>";
        #   run = "close";
        #   desc = "Close current tab";
        # }
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
            "m"
          ];
          run = "cd ~/Documents/MuseScore3/Scores";
          desc = "Go ~/Documents/MuseScore3/Scores";
        }
        {
          on = [
            "g"
            "M"
          ];
          run = "cd ~/Documents/MuseScore4/Scores";
          desc = "Go ~/Documents/MuseScore4/Scores";
        }
        {
          on = [
            "g"
            "."
          ];
          run = "cd ~/dotfiles";
          desc = "Go ~/dotfiles";
        }
        {
          on = [
            "g"
            "l"
          ];
          run = "cd ~/.local";
          desc = "Go ~/.local";
        }
        {
          on = [
            "g"
            "P"
          ];
          run = "cd ~/Pictures";
          desc = "Go ~/Pictures";
        }
        {
          on = [
            "g"
            "S"
          ];
          run = "cd ~/Pictures/Screenshots";
          desc = "Go ~/Pictures/Screenshots";
        }
        {
          on = [
            "g"
            "V"
          ];
          run = "cd ~/Videos";
          desc = "Go ~/Videos";
        }
        {
          on = [
            "g"
            "O"
          ];
          run = "cd ~/Obsidian-Vaults";
          desc = "Go ~/Obsidian-Vaults";
        }

        #
        # Plugins
        #

        # Close and restore tab plugin
        {
          on = "<C-w>";
          run = "plugin close-and-restore-tab close_to_left";
          desc = "Close the current tab and turn to left tab, or quit if it is last tab";
        }
        {
          on = "<C-T>";
          run = "plugin close-and-restore-tab restore";
          desc = "Restore the closed tab";
        }
        # Smart paste plugin
        {
          on = "P";
          run = "plugin smart-paste";
          desc = "Paste into the hovered directory or CWD";
        }

        # Jump to char plugin
        {
          on = "F";
          run = "plugin jump-to-char";
          desc = "Jump to char";
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

        # Convert plugin
        {
          on = [
            "c"
            "p"
          ];
          run = "plugin convert -- --extension='png'";
          desc = "Convert selected files to PNG";
        }
        {
          on = [
            "c"
            "j"
          ];
          run = "plugin convert -- --extension='jpg'";
          desc = "Convert selected files to JPG";
        }
        {
          on = [
            "c"
            "w"
          ];
          run = "plugin convert -- --extension='webp'";
          desc = "Convert selected files to WebP";
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
  };
}
