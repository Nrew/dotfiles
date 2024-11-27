# modules/cli/lazygit.nix
{ config, lib, pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        scrollHeight = 2;
        scrollPastBottom = true;
        mouseEvents = true;
        skipUnstageLineWarning = false;
        skipStashWarning = true;
        showFileTree = true;
        showRandomTip = false;
        expandFocusedSidePanel = false;
        mainPanelSplitMode = "flexible";
        theme = {
          lightTheme = false;
          activeBorderColor = ["${config.home.homeDirectory}/.cache/wal/colors.sh:color4" "bold"];
          inactiveBorderColor = ["${config.home.homeDirectory}/.cache/wal/colors.sh:color8"];
          selectedLineBgColor = ["${config.home.homeDirectory}/.cache/wal/colors.sh:color0"];
          cherryPickedCommitBgColor = ["${config.home.homeDirectory}/.cache/wal/colors.sh:color1"];
          cherryPickedCommitFgColor = ["${config.home.homeDirectory}/.cache/wal/colors.sh:color15"];
          unstagedChangesColor = ["${config.home.homeDirectory}/.cache/wal/colors.sh:color1"];
        };
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        commit = {
          signOff = false;
        };
        merging = {
          manualCommit = false;
          args = "";
        };
        skipHookPrefix = "WIP";
        autoFetch = true;
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' {{branchName}} --";
        allBranchesLogCmd = "git log --graph --all --color=always --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'";
        overrideGpg = false;
        disableForcePushing = false;
      };
      update = {
        method = "never";
      };
      confirmOnQuit = false;
      keybinding = {
        universal = {
          quit = "q";
          quit-alt1 = "<c-c>";
          return = "<esc>";
          quitWithoutChangingDirectory = "Q";
          togglePanel = "<tab>";
          prevItem = "<up>";
          nextItem = "<down>";
          prevBlock = "<left>";
          nextBlock = "<right>";
          prevBlock-alt = "h";
          nextBlock-alt = "l";
          prevItem-alt = "k";
          nextItem-alt = "j";
          scrollUpMain = "<pgup>";
          scrollDownMain = "<pgdown>";
          scrollUpMain-alt1 = "K";
          scrollDownMain-alt1 = "J";
          scrollUpMain-alt2 = "<c-u>";
          scrollDownMain-alt2 = "<c-d>";
          redo = "U";
          undo = "u";
          refresh = "R";
        };
        files = {
          commitChanges = "c";
          commitChangesWithEditor = "C";
          amendLastCommit = "A";
          stashAllChanges = "s";
          viewStashOptions = "S";
          toggleStagedAll = "<c-s>";
          viewResetOptions = "D";
          fetch = "f";
          toggleTreeView = "`";
        };
        branches = {
          createPullRequest = "o";
          viewPullRequestOptions = "O";
          checkoutBranchByName = "c";
          forceCheckoutBranch = "F";
          rebaseBranch = "r";
          mergeIntoCurrentBranch = "M";
          viewGitFlowOptions = "i";
          fastForward = "f";
          pushTag = "P";
          setUpstream = "u";
          fetchRemote = "f";
        };
      };
    };
  };

  # Add shell alias
  programs.zsh.shellAliases = {
    lg = "lazygit";
  };
}