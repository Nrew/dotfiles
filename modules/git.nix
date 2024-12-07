# modules/cli/git.nix
{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # Delta for better diffs
    delta = {
      enable = true;
      options = {
        features = "decorations";
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "base16";
      };
    };

    # Basic configuration
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        editor = "nvim";
        whitespace = "trailing-space,space-before-tab";
      };
      color = {
        ui = true;
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
      help = {
        autocorrect = 1;
      };
      diff = {
        colorMoved = "default";
      };
      merge = {
        conflictstyle = "diff3";
      };
      rebase = {
        autosquash = true;
        autostash = true;
      };
      url = {
        "git@github.com:" = {
          insteadOf = "gh:";
        };
      };
    };

    # Useful aliases
    aliases = {
      # Basic shortcuts
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status -sb";
      df = "diff";
      dc = "diff --cached";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
      ls = "log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]' --decorate";
      
      # Work with branches
      bb = "branch -v";
      bd = "branch -d";
      bdd = "branch -D";
      
      # Commit related
      amend = "commit --amend -C HEAD";
      undo = "reset HEAD~1 --mixed";
      unstage = "reset HEAD --";
      
      # Stash operations
      sl = "stash list";
      sa = "stash apply";
      ss = "stash save";
      sp = "stash pop";
      
      # Show
      who = "shortlog -s --";
      
      # Find
      find = "!git ls-files | grep -i";
      
      # List aliases
      aliases = "!git config --get-regexp '^alias\\.' | sed 's/alias\\.\\([^ ]*\\) \\(.*\\)/\\1\\\t => \\2/' | sort";
      
      # Show files ignored by git
      ign = "ls-files -o -i --exclude-standard";
    };

    # Sign commits if GPG key is available
    signing = {
      key = null;
      signByDefault = false;
    };

    # LFS support
    lfs.enable = true;

    # Useful ignores
    ignores = [
      # macOS
      ".DS_Store"
      "*.swp"
      ".Spotlight-V100"
      ".Trashes"

      # Editor specific
      ".vscode/"
      ".idea/"
      "*.sublime-workspace"
      "*.sublime-project"
      ".vim/"
      "*.swp"
      "*.swo"
      "*~"

      # Node
      "node_modules/"
      "npm-debug.log"
      "yarn-error.log"
      ".npm/"
      ".yarn/"

      # Python
      "__pycache__/"
      "*.py[cod]"
      "*$py.class"
      ".Python"
      "env/"
      "venv/"
      ".env"
      ".venv"
      "pip-log.txt"
      "pip-delete-this-directory.txt"
      ".tox/"
      ".coverage"
      ".coverage.*"
      ".cache"
      "nosetests.xml"
      "coverage.xml"
      "*.cover"
      
      # Nix
      "result"
      "result-*"

      # Build outputs
      "dist/"
      "build/"
      "*.egg-info/"
    ];
  };

  # Install additional git tools
  home.packages = with pkgs; [
    git-absorb    # automatically absorb staged changes into previous commits
    git-revise    # rewrite git commit history
    git-branchless # streamlined workflow for stacked changes
  ];
}