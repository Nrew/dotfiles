 {...}: 
 
 {
    # ────────────────────────────────────────────────────────────────
    # Zsh Configuration
    # ────────────────────────────────────────────────────────────────

    programs.zsh = {
        enable = true;                   # Enable Zsh as the default shell
        enableCompletion = true;

        shellAliases = {
            ll = "ls -la";               # List files in long format
            gs = "git status";           # Git status shortcut
            vim = "nvim";                # Alias Vim to Neovim
        };
    };
}
