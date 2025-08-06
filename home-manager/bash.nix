{ ... }:
{
  programs.bash = {
    enable = true;
    historyControl = [ "ignoreboth" ];
    initExtra = ''
      # fix history across tmux windows
      shopt -s histappend
      shopt -s histreedit
      shopt -s histverify
      PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

      # terminal styling
      PS1="\[\033[1;35m\]\! \[\033[1;34m\][\u@\h:\w]\$ \[\033[0m\]"
      if [ "$TERM" = "linux" ]; then
          echo -en "\e]P0101010"  # black
          echo -en "\e]P85B5B5B"  # darkgrey
          echo -en "\e]P19D1515"  # darkred
          echo -en "\e]P9E33636"  # red
          echo -en "\e]P200800B"  # darkgreen
          echo -en "\e]PA8DE336"  # green
          echo -en "\e]P3E38D36"  # brown
          echo -en "\e]PBE3E336"  # yellow
          echo -en "\e]P415599E"  # darkblue
          echo -en "\e]PC348DE5"  # blue
          echo -en "\e]P59E1559"  # darkmagenta
          echo -en "\e]PDE5348D"  # magenta
          echo -en "\e]P6159E9E"  # darkcyan
          echo -en "\e]PE34E5E5"  # cyan
          echo -en "\e]P7E5E5E5"  # lightgrey
          echo -en "\e]PFFFFFFF"  # white
          clear                   # for background artifacting
      fi
    '';
  };

}
