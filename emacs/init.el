(defconst my/configuration-org "~/.dotfiles/emacs/configuration.org")
(defconst my/configuration-el "~/.dotfiles/emacs/configuration.el")

(if (file-exists-p my/configuration-el)
  (load-file my/configuration-el)
  (org-babel-load-file my/configuration-org))
