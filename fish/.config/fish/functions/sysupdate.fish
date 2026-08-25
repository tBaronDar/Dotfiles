function sysupdate --description 'Update Homebrew packages and mise tools'
    echo "== Updating Homebrew packages =="
    brew update
    or return 1
    brew upgrade
    or return 1

    echo "== Updating mise tools =="
    mise upgrade
end
