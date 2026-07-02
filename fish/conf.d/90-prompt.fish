set -g fish_color_autosuggestion 585858
if command -v starship >/dev/null
    starship init fish | source
end
