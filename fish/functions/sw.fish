function sw --description 'Toggle Termux color theme'
    set -l target "$HOME/.termux/colors.properties"
    set -l themes "$HOME/.termux/themes"

    if grep -q '222436' $target 2>/dev/null
        cp "$themes/catppuccin-latte.properties" $target
        echo "→ Catppuccin Latte"
    else
        cp "$themes/tokyonight-moon.properties" $target
        echo "→ Tokyonight Moon"
    end

    termux-reload-settings
end
