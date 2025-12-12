{ config, lib, pkgs, ... }:
let
    name = "Nrew";
    user = "nrew";
    email = "andrew.sayegh29@gmail.com";
in
{

  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    if [ -f "${config.home.homeDirectory}/.gitconfig" ]; then
      rm -f "${config.home.homeDirectory}/.gitconfig"
    fi
  '';

  # ────────────────────────────────────────────────────────────────
  # Core Git Package and Extensions
  # ────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    git-absorb     # automatically absorb staged changes into previous commits
    git-revise     # rewrite git commit history
    git-branchless # streamlined workflow for stacked changes
  ];

  # ────────────────────────────────────────────────────────────────
  # Diff & Merge Tools Configuration
  # ────────────────────────────────────────────────────────────────
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      diff-so-fancy = true;
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
    };
  };

  programs.git = {
    enable = true;

    # ────────────────────────────────────────────────────────────────
    # Git LFS Configuration
    # ────────────────────────────────────────────────────────────────
    lfs.enable = true;

    # ────────────────────────────────────────────────────────────────
    # Core Git Configuration
    # ────────────────────────────────────────────────────────────────
    settings = {
      user = {
        name = name;
        email = email;
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      
      # Core settings
      core = {
        whitespace = "trailing-space,space-before-tab";
        autocrlf = "input";
      };

      # UI configuration
      color = {
        ui = true;
        diff = "auto";
        status = "auto";
        branch = "auto";
      };

      # Helper settings
      help.autocorrect = 1;

      # Diff and merge settings
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";

      # Rebase configuration
      rebase = {
        autosquash = true;
        autostash = true;
      };

      # Security settings
      # commit.gpgSign = true;

      # Remote URL shortcuts
      url."git@github.com:".insteadOf = "gh:";
    

      # ────────────────────────────────────────────────────────────────
      # Git Aliases
      # ────────────────────────────────────────────────────────────────
      alias = {
        # Basic operations
        br = "branch";
        ci = "commit";
        co = "checkout";
        st = "status -sb";
        
        # Diff operations
        df = "diff";
        dc = "diff --cached";

        # Log viewing
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
        ls = "log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]' --decorate";
        
        # Branch management
        bb = "branch -v";
        bd = "branch -d";
        bdd = "branch -D";
        
        # Commit operations
        amend = "commit --amend -C HEAD";
        undo = "reset HEAD~1 --mixed";
        unstage = "reset HEAD --";
        
        # Stash operations
        sa = "stash apply";
        sl = "stash list";
        sp = "stash pop";
        ss = "stash save";
        
        # Utility
        aliases = "!git config --get-regexp '^alias\\.' | sed 's/alias\\.\\([^ ]*\\) \\(.*\\)/\\1\\\t => \\2/' | sort";
        find = "!git ls-files | grep -i";
        ign = "ls-files -o -i --exclude-standard";
        who = "shortlog -s --";
      };
    };

    # ────────────────────────────────────────────────────────────────
    # Git Ignore Patterns
    # ────────────────────────────────────────────────────────────────
    ignores = [
      # Version control
      ".git/"

      # Build outputs
      "dist/"
      "build/"
      "*.egg-info/"
      "result"
      "result-*"

      # Development environments
      ".env"
      ".venv"
      "env/"
      "venv/"
      "__pycache__/"
      "node_modules/"
      ".npm/"
      ".yarn/"

      # Logs and databases
      "*.log"
      "*.sqlite"
      ".coverage"
      ".coverage.*"
      "coverage.xml"
      "nosetests.xml"

      # OS generated files
      ".DS_Store"
      ".Spotlight-V100"
      ".Trashes"
      "Thumbs.db"

      # Temporary files
      "*~"
      "*.swp"
      "*.swo"
      ".cache"
    ];
  };
}
