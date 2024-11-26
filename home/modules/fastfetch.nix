{pkgs, ...}:
{
    # Install fastfetch via home-manager package
    home.packages = with pkgs; [
        fastfetch
    ];
    
}