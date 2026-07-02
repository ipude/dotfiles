set -gx GOROOT (go env GOROOT)
set -gx GOPATH $HOME/go           
fish_add_path $GOPATH/bin
fish_add_path $HOME/.cargo/bin
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx LESS '-R -F -X -i -M -W -q'
set -gx CARGO_TARGET_DIR "$HOME/.cargo_targets"
set -gx RUSTC_WRAPPER sccache
set -gx TMPDIR /data/data/com.termux/files/usr/tmp
