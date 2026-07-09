set -gx GOROOT (go env GOROOT)
set -gx GOPATH $HOME/go           
fish_add_path $GOPATH/bin
fish_add_path $HOME/.cargo/bin
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx LESS '-R -F -X -i -M -W -q'

# conf.d/00-env.fish
set -gx CARGO_HOME "$HOME/.CARGO_HOME"
set -gx RUSTUP_HOME "$HOME/.RUSTUP_HOME"
set -gx CARGO_TARGET_DIR "$HOME/.CARGO_TARGET_DIR"
set -gx RUSTC_WRAPPER sccache
fish_add_path "$CARGO_HOME/bin"
set -gx TMPDIR /data/data/com.termux/files/usr/tmp
