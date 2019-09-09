;; base16-my-theme-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/chriskempson/base16)

;;; Authors:
;; Andrey Koppel (akoppela@gmail.com)

;;; Code:

(require 'base16-theme)

(defvar base16-my-theme-base00 "#000000")
(defvar base16-my-theme-base01 "#363636")
(defvar base16-my-theme-base02 "#505050")
(defvar base16-my-theme-base03 "#808080")
(defvar base16-my-theme-base04 "#d0d0d0")
(defvar base16-my-theme-base05 "#e0e0e0")
(defvar base16-my-theme-base06 "#f5f5f5")
(defvar base16-my-theme-base07 "#ffffff")
(defvar base16-my-theme-base08 "#fb0120")
(defvar base16-my-theme-base09 "#fe8625")
(defvar base16-my-theme-base0A "#fda331")
(defvar base16-my-theme-base0B "#a1c659")
(defvar base16-my-theme-base0C "#76c7b7")
(defvar base16-my-theme-base0D "#6fb3d2")
(defvar base16-my-theme-base0E "#d381c3")
(defvar base16-my-theme-base0F "#be643c")

(defvar base16-my-theme-colors
  `(:base00 ,base16-my-theme-base00
    :base01 ,base16-my-theme-base01
    :base02 ,base16-my-theme-base02
    :base03 ,base16-my-theme-base03
    :base04 ,base16-my-theme-base04
    :base05 ,base16-my-theme-base05
    :base06 ,base16-my-theme-base06
    :base07 ,base16-my-theme-base07
    :base08 ,base16-my-theme-base08
    :base09 ,base16-my-theme-base09
    :base0A ,base16-my-theme-base0A
    :base0B ,base16-my-theme-base0B
    :base0C ,base16-my-theme-base0C
    :base0D ,base16-my-theme-base0D
    :base0E ,base16-my-theme-base0E
    :base0F ,base16-my-theme-base0F)
  "All colors for my Base16 theme are defined here.")

;; Define the theme
(deftheme base16-my-theme)

;; Add all the faces to the theme
(base16-theme-define 'base16-my-theme base16-my-theme-colors)

;; Mark the theme as provided
(provide-theme 'base16-my-theme)

(provide 'base16-my-theme)

;;; base16-my-theme-theme.el ends here
