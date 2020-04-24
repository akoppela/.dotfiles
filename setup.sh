#! /bin/sh

# Create
touch ~/.secret-profile

# Stow
cd ~/.dotfiles && stow bash
cd ~/.dotfiles && stow emacs
cd ~/.dotfiles && stow git
