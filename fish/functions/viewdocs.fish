function viewdocs --description 'View docs of any lib, e.g. viewdocs github.com/urfave/@v3'
    set -l pkg $argv[1]
    set -l dir (fd --type d --glob "*"(basename $pkg)"*" (go env GOMODCACHE) | head -1)
    if test -d "$dir"
        cd $dir && ~/go/bin/pkgsite -open .
    else
        echo "Module not found. Run: go get $pkg"
    end
end
