;; base16-my-dark-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/chriskempson/base16)

;;; Authors:
;; Andrey Koppel (akoppela@gmail.com)
;; Template: Chris Kempson (http://chriskempson.com)

;;; Code:

(require 'base16-theme)

(defvar base16-my-dark-base00 "#000000")
(defvar base16-my-dark-base01 "#363636")
(defvar base16-my-dark-base02 "#505050")
(defvar base16-my-dark-base03 "#808080")
(defvar base16-my-dark-base04 "#d0d0d0")
(defvar base16-my-dark-base05 "#e0e0e0")
(defvar base16-my-dark-base06 "#f5f5f5")
(defvar base16-my-dark-base07 "#ffffff")
(defvar base16-my-dark-base08 "#fb0120")
(defvar base16-my-dark-base09 "#fe8625")
(defvar base16-my-dark-base0A "#fda331")
(defvar base16-my-dark-base0B "#a1c659")
(defvar base16-my-dark-base0C "#76c7b7")
(defvar base16-my-dark-base0D "#6fb3d2")
(defvar base16-my-dark-base0E "#d381c3")
(defvar base16-my-dark-base0F "#be643c")

(defvar base16-my-dark-colors
  `(:base00 ,base16-my-dark-base00
    :base01 ,base16-my-dark-base01
    :base02 ,base16-my-dark-base02
    :base03 ,base16-my-dark-base03
    :base04 ,base16-my-dark-base04
    :base05 ,base16-my-dark-base05
    :base06 ,base16-my-dark-base06
    :base07 ,base16-my-dark-base07
    :base08 ,base16-my-dark-base08
    :base09 ,base16-my-dark-base09
    :base0A ,base16-my-dark-base0A
    :base0B ,base16-my-dark-base0B
    :base0C ,base16-my-dark-base0C
    :base0D ,base16-my-dark-base0D
    :base0E ,base16-my-dark-base0E
    :base0F ,base16-my-dark-base0F)
  "All colors for my Base16 dark theme are defined here.")

;; Define the theme
(deftheme base16-my-dark)

;; Add all the faces to the theme
(base16-theme-define 'base16-my-dark base16-my-dark-colors)

;; Mark the theme as provided
(provide-theme 'base16-my-dark)

(provide 'base16-my-dark)

;;; base16-my-dark-theme.el ends here
