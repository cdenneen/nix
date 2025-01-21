{ pkgs, ...}:
  with pkgs;
let
   tmux-nvim = tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-nvim";
    version = "unstable-2025-01-10";
    src = fetchFromGitHub {
      owner = "aserowy";
      repo = "tmux.nvim";
      rev = "main";
      sha256 = "sha256-c/1swuJ6pIiaU8+i62Di/1L/b4V9+5WIVzVVSJJ4ls8=";
    };
  };
in
{
  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = false;
    customPaneNavigationAndResize = false;
    enable = true;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    newSession = true;
    plugins = with tmuxPlugins; [
      #tmux-nvim
      yank
      vim-tmux-navigator
      { 
        plugin = tmux-thumbs;
        extraConfig = ''
          # sticky fingers
          unbind f
          set -g @thumbs-key f
          set -g @thumbs-contrast 1
          set -g @thumbs-bg-color '#b968fc'
          set -g @thumbs-fg-color '#201430'
          set -g @thumbs-hint-bg-color '#87ff5f'
          set -g @thumbs-hint-fg-color '#201430'
          set -g @thumbs-select-bg-color '#9CDA7C'
          set -g @thumbs-select-fg-color '#201430'
          set -g @thumbs-command 'printf "{}" | yank'
        '';
      }
      {
        plugin = mode-indicator;
        extraConfig = ''
          # status icon
          set -g @mode_indicator_empty_prompt ' ◇ '
          set -g @mode_indicator_empty_mode_style 'bg=term,fg=color2'
          set -g @mode_indicator_prefix_prompt ' ◈ '
          set -g @mode_indicator_prefix_mode_style 'bg=color2,fg=color0'
          set -g @mode_indicator_copy_prompt '  '
          set -g @mode_indicator_copy_mode_style 'bg=color10,fg=color0'
          set -g @mode_indicator_sync_prompt '   '
          set -g @mode_indicator_sync_mode_style 'bg=color6,fg=color0'
        '';
      }
      mode-indicator
      resurrect
      continuum
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "kubernetes-context git terraform cwd ram-usage cpu-usge time"
          set -g @dracula-kubernetes-eks-hide-arn true
          set -g @dracula-kubernetes-eks-extra-account true
          set -g @dracula-refresh-rate 10
        '';
      }
      sensible
    ];
    resizeAmount = 5;
    reverseSplit = false;
    secureSocket = false;
    shortcut = "l";
    terminal = "xterm-256color";
    mouse = true;

    extraConfig = ''
      set -g default-command /run/current-system/sw/bin/zsh
      set-window-option -g mode-keys vi

      # renumber windows after closing
      set -g renumber-windows on
      # start with pane 1
      set -g pane-base-index 1

      set -ga terminal-overrides ",*256col*:Tc"

      # focusing
      set-option -g focus-events on
      
      # panes
      set -g pane-border-style "fg=color0"
      set -g pane-border-lines "heavy"
      set -g pane-active-border-style "fg=color0"
      set -g window-active-style 'bg=terminal'
      set -g window-style 'bg=#1c1427'
      
      # status line
      set -g status-justify left
      set -g status-style "bg=terminal,fg=color10"
      set -g status-interval 2
      
      # messaging
      set -g message-style "bg=color4,fg=color10"
      set -g message-command-style "bg=color12,fg=color2"
      
      # window mode
      setw -g mode-style "bg=color8,fg=color4"
      
      # split sytle
      set -g pane-border-style "bg=color0,fg=color5"
      set -g pane-active-border-style "bg=color0,fg=color5"

      # window status
      set-option -g status-position bottom
      setw -g window-status-format " #[bg=color4,fg=color0,noreverse]▓░ #W "
      setw -g window-status-current-format " #[bg=color10,fg=color0,noreverse]▓░ #W "
      
      # loud or quiet?
      set-option -g visual-activity on
      set-option -g visual-bell off
      set-option -g visual-silence off
      set-window-option -g monitor-activity off
      set-option -g bell-action none
      
      # tmux clock
      set -g clock-mode-color color4

      # splitting
      unbind %
      bind h split-window -v
      unbind '"'
      bind v split-window -h
      
      # zoom split
      unbind z
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind z if-shell "$is_vim" "send-keys ,z" "resize-pane -Z"
      bind Z resize-pane -Z
      
      # vim style commands
      bind : command-prompt
      
      # source config file
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "█▓░ reloaded"
      
      # other random key-binding changes
      bind x kill-pane
      bind t set status
      bind a set-window-option synchronize-panes \; display-message "█▓░ synchronize"

      set -s set-clipboard on
      set -g @yank_selection_mouse 'clipboard'
      set -g @yank_action 'copy-pipe-and-cancel "xclip -in -selection clipboard"'

      bind -n C-k send-keys "clear"\; send-keys "Enter"
    '';
  };
}
