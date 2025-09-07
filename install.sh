#!/usr/bin/env sh

# Installation script for config-zsh

point_zsh_to_this_config() {
  config_file=$1
  echo "Pointing zsh to this config"
  if [ -L ~/.zshrc ]; then
    echo "zsh config already set - verifying it points to this config"
    local actual_resolved_path
    actual_resolved_path=$(readlink -f ~/.zshrc)
    if [ "$actual_resolved_path" = "$(pwd)/${config_file}" ]; then
      echo "zsh is already pointing to this config"
    else
      echo "zsh is pointing to another config: ${actual_resolved_path}"
      exit 1
    fi
  else
    if [ -f ~/.zshrc ]; then
      echo "zsh config already exists - moving it to backup"
      mv ~/.zshrc{,.bak}
    fi
    echo "Linking zsh to this config"
    ln -s $(pwd)/${config_file} ~/.zshrc
  fi
}

main() {

  if [ -e zshrc.omarchy ]; then
    if [ -f /etc/arch-release ]; then
      echo "Omarchy detected"
      point_zsh_to_this_config zshrc.omarchy 
    elif [ -f /etc/os-release ]; then 
      ID=$(awk -F= '/^ID=/{gsub(/"/, "", $2); print $2}' /etc/os-release) 
      echo "$ID"
      if [ "$ID" = "linuxmint" ]; then 
        echo "Installing for Linux Mint" 
        point_zsh_to_this_config zshrc.linuxmint
      else 
        echo "Unsupported OS"
      fi
    elif [[ $(uname) == "Darwin" ]]; then
      echo "macOS detected"
      point_zsh_to_this_config zshrc.macOS 
    else 
      echo "Unsupported OS"
    fi
  else
    echo "You need to run this script from within the config-zsh directory"
  fi
}

main
