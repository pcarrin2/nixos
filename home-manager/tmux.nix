{
  ...
}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    sensibleOnTop = true;
    keyMode = "vi";
    extraConfig = ''
      # carry over current directory when splitting panes
      bind '"' split-window -v -c "#{pane_current_path}"
      bind 'b' split-window -h -c "#{pane_current_path}"

      # mouse compatibility
      set -g mouse on

      # avoid gaps in numbering if a window is closed
      set -g renumber-windows on
      
      # monitor bell for status-line display
      set -g monitor-bell on

      # pane border color
      set -g pane-active-border-style 'fg=blue'

      # status bar config
      set -g status-style 'bg=blue fg=white'
      set -g status-interval 1
      set -g status-left '[#(whoami)@#(hostname)] '
      set -g status-left-length 20
      
      # right-hand status: battery info, then time
      set -g status-right '#(cat /sys/class/power_supply/BAT0/capacity)%%, #(cat /sys/class/power_supply/BAT0/status) | %Y-%m-%d %H:%M:%S'
      
      # styling the list of windows
      set -g window-status-style 'fg=black bg=blue'
      set -g window-status-current-style 'fg=blue bg=black'
      set -g window-status-bell-style 'fg=brightwhite bg=magenta'
      set -g window-status-format ' #I '
      set -g window-status-current-format ' #I '

      # vim-style pane navigation (overwrites some default keybinds, sorry)
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # display information about character under cursor
      bind-key -T copy-mode-vi u \
        send-keys -X begin-selection \; \
        send-keys -X pipe "xargs tmux display \"$(xargs unicode --format \'U+{ordc:04x}: {name}\')\"" \;
      bind-key u run-shell "tmux display \"$(unicode \"#{cursor_character}\" --format \'U+{ordc:04x}: {name}\')\""
    '';
  };
}
