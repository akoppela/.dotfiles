;; base16-my-light-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/chriskempson/base16)

;;; Authors:
;; Andrey Koppel (akoppela@gmail.com)
;; Template: Chris Kempson (http://chriskempson.com)

;;; Code:

(require 'base16-theme)

(defvar base16-my-light-base00 "#ffffff")
(defvar base16-my-light-base01 "#e0e0e0")
(defvar base16-my-light-base02 "#d6d6d6")
(defvar base16-my-light-base03 "#8e908c")
(defvar base16-my-light-base04 "#969896")
(defvar base16-my-light-base05 "#4d4d4c")
(defvar base16-my-light-base06 "#282a2e")
(defvar base16-my-light-base07 "#1d1f21")
(defvar base16-my-light-base08 "#c82829")
(defvar base16-my-light-base09 "#f5871f")
(defvar base16-my-light-base0A "#eab700")
(defvar base16-my-light-base0B "#718c00")
(defvar base16-my-light-base0C "#3e999f")
(defvar base16-my-light-base0D "#4271ae")
(defvar base16-my-light-base0E "#8959a8")
(defvar base16-my-light-base0F "#a3685a")

(defvar base16-my-light-colors
  `(:base00 ,base16-my-light-base00
    :base01 ,base16-my-light-base01
    :base02 ,base16-my-light-base02
    :base03 ,base16-my-light-base03
    :base04 ,base16-my-light-base04
    :base05 ,base16-my-light-base05
    :base06 ,base16-my-light-base06
    :base07 ,base16-my-light-base07
    :base08 ,base16-my-light-base08
    :base09 ,base16-my-light-base09
    :base0A ,base16-my-light-base0A
    :base0B ,base16-my-light-base0B
    :base0C ,base16-my-light-base0C
    :base0D ,base16-my-light-base0D
    :base0E ,base16-my-light-base0E
    :base0F ,base16-my-light-base0F)
  "All colors for my Base16 light theme are defined here.")

;; Define the theme
(deftheme base16-my-light)

;; Add all the faces to the theme
(base16-theme-define 'base16-my-light base16-my-light-colors)

;; Mark the theme as provided
(provide-theme 'base16-my-light)

(provide 'base16-my-light)

;;; base16-my-light-theme.el ends here
