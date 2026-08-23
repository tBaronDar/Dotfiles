function sysupdate --description 'Update system packages, flatpaks, and mise tools'
    echo "== Updating pacman packages =="
    sudo pacman -Syu --noconfirm
    or return 1

    echo "== Updating flatpaks =="
    flatpak update -y
    or return 1

    echo "== Updating mise tools =="
    mise upgrade
end
