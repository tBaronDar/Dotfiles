sysupdate() {
  echo "Updating brew packages..."
  brew update || return 1
  brew upgrade || return 1

  echo "Updating mise packages..." 
  mise upgrade || return 1

  echo "System packages updated."
}
