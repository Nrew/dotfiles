{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # History configuration
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 10000;
      ignoreDups = true;
      share = true;
      extended = true;
    };

    # Initialize plugins
    initExtra = ''
      # Run fastfetch on shell start (only in kitty terminal)
      if [[ -n "$KITTY_WINDOW_ID" ]] && command -v fastfetch &> /dev/null; then
        fastfetch
      fi

      # Better history search
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^[[A" up-line-or-beginning-search
      bindkey "^[[B" down-line-or-beginning-search

      # Fix backspace in vi mode
      bindkey "^?" backward-delete-char

      # Better word navigation
      export WORDCHARS=''${WORDCHARS/\//}

      # Directory stack
      setopt AUTO_PUSHD           # Push directories automatically
      setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
      setopt PUSHD_SILENT         # Don't print directory stack

      # Completion improvements
      setopt COMPLETE_IN_WORD     # Complete from both ends of a word
      setopt ALWAYS_TO_END        # Move cursor to end after completion
      setopt PATH_DIRS            # Perform path search even on commands with slashes
      setopt AUTO_MENU            # Show completion menu on tab press
      setopt COMPLETE_ALIASES     # Complete aliases

      # History improvements
      setopt EXTENDED_HISTORY          # Write timestamps to history
      setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first
      setopt HIST_IGNORE_DUPS          # Don't record duplicates
      setopt HIST_FIND_NO_DUPS         # Don't show duplicates when searching
      setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
      setopt HIST_VERIFY               # Don't execute immediately upon history expansion

      # Job control
      setopt LONG_LIST_JOBS        # List jobs in long format
      setopt AUTO_RESUME          # Resume existing jobs instead of creating new ones
      setopt NOTIFY              # Report status of background jobs immediately

      # Input/Output
      setopt CORRECT              # Command correction
      setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
      setopt RC_QUOTES            #
      unsetopt FLOW_CONTROL       # Disable start/stop characters in shell editor

      # Load custom functions
      #for func in ${config.home.homeDirectory}/zsh/functions/*; do
      #  source $func
      #done
    '';

    # Shell aliases
    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # Git
      g = "git";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gd = "git diff";
      gp = "git push";
      gpl = "git pull";
      gs = "git status";
      gst = "git status";

      # Vim
      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      # System
      grep = "rg";
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      mkdir = "mkdir -p";

      # Utils
      h = "history";
      j = "jobs -l";
      path = "echo -e \${PATH//:/\\n}";
      ports = "sudo lsof -iTCP -sTCP:LISTEN -n -P";
    };

    # ZSH plugins
    plugins = [
    ];
  };
}
