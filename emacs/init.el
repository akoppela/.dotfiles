(defconst my/configuration-path (expand-file-name "~/.dotfiles/emacs/configuration.org"))

(defun my/open-configuration ()
  "Opens emacs configuration."
  (interactive)
  (find-file my/configuration-path))

(defun my/load-configuration ()
  "Loads/reloads emacs configuration at runtime."
  (interactive)
  (org-babel-load-file my/configuration-path))

(my/load-configuration)
