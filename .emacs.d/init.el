;;; package --- Summary this is my .emacs file

;;; PACKAGE INITIALISATION

(require 'package)
;initialise package.el
(package-initialize)


;;; Code

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(highlight-nonselected-windows t)
 '(js2-highlight-external-variables nil)
 '(js2-idle-timer-delay 0)
 '(js2-include-node-externs t)
 '(js2-mode-assume-strict t)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/"))))
 '(package-selected-packages
   (quote
    (neotree ob-php org-bullets magit php-mode rainbow-mode js2-mode web-mode ac-html processing-mode multiple-cursors yasnippet which-key try smart-mode-line-powerline-theme org jedi hungry-delete flycheck expand-region counsel)))
 '(php-mode-coding-style (quote symfony2))
 '(python-indent-guess-indent-offset-verbose nil)
 '(python-shell-interpreter "python3.6")
 '(sh-indentation 2)
 '(web-mode-enable-auto-closing t)
 '(web-mode-enable-auto-expanding t)
 '(web-mode-enable-auto-indentation nil t)
 '(web-mode-enable-auto-opening t)
 '(web-mode-enable-auto-pairing t)
 '(web-mode-enable-current-element-highlight t)
 '(web-mode-enable-engine-detection t)
 '(web-mode-enable-html-entities-fontification t)
 '(web-mode-enable-part-face t)
 '(web-mode-enable-sql-detection t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-comment ((t (:background "color-235" :foreground "black"))))
 '(font-lock-comment-face ((t (:foreground "brightblack" :slant italic))))
 '(font-lock-function-name-face ((t (:foreground "green"))))
 '(font-lock-keyword-face ((t (:foreground "color-33" :weight semi-light))))
 '(font-lock-negation-char-face ((t (:foreground "color-210"))))
 '(font-lock-preprocessor-face ((t (:foreground "brightmagenta" :weight semi-bold))))
 '(font-lock-string-face ((t (:foreground "color-89"))))
 '(font-lock-type-face ((t (:foreground "color-38" :underline t :weight ultra-bold))))
 '(font-lock-variable-name-face ((t (:foreground "color-166"))))
 '(highlight ((t (:background "color-236"))))
 '(ivy-minibuffer-match-face-1 ((t (:background "brightblue" :foreground "black"))))
 '(ivy-minibuffer-match-face-2 ((t (:background "cyan" :foreground "color-16" :weight bold))))
 '(ivy-minibuffer-match-face-3 ((t (:background "#ffffff" :foreground "color-16" :weight bold))))
 '(js2-function-call ((t (:foreground "color-162" :slant italic :weight semi-bold))))
 '(js2-function-param ((t (:foreground "color-243"))))
 '(js2-object-property ((t (:foreground "color-248"))))
 '(org-table ((t (:foreground "color-248"))))
 '(secondary-selection ((t (:background "color-235"))))
 '(show-paren-match ((t (:background "color-245" :foreground "color-232"))))
 '(which-func ((t (:inherit font-lock-function-name-face))))
 '(which-key-command-description-face ((t (:inherit font-lock-function-name-face :foreground "color-23"))))
 '(widget-field ((t (:background "color-235" :foreground "white"))))
 '(widget-inactive ((t (:distant-foreground "black" :foreground "color-250"))))
 '(yas-field-highlight-face ((t ((quote region) nil :background "#000")))))


;;; CUSTOM MODELINE THEME
(setq sml/theme 'automatic)
(sml/setup)



;;; UTILITY SETTINGS

(display-time)
(fset 'yes-or-no-p 'y-or-n-p) ; use y,n instead of full 'yes' or 'no'
(setq initial-scratch-message nil) ; disable scratch startup message
(setq inhibit-startup-message t) ; disable all startup emacs message and stuff
(defun display-startup-echo-area-message () (message "")) ;; Hide messages from minibuffer
(set-face-inverse-video 'vertical-border nil);Reverse colors for the middle line separator
(set-face-background 'vertical-border (face-background 'default))
(set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))
;; Highlight matching parenthesis
(show-paren-mode 1)
(setq show-paren-style 'mixed)
(electric-pair-mode 1)   ;matching brackets autocompletion
(global-linum-mode t)  ; adds the line numbers
(setq linum-format "%2d ") ;number format. space after number and display in 01, 02 format
(delete-selection-mode 1) ;replace and delete on selection
(menu-bar-mode -1) ;disable menu bar
(tool-bar-mode -1)
(setq column-number-mode t) ;display both lines and columns in the mode line
(setq make-backup-files nil) ; stop creating backup~ files
(electric-indent-mode t) ; indent automatically
(visual-line-mode t); better wrapping


;;; KEYBOARD LAYOUT ON MAC
(define-key input-decode-map "\e[1;2A" [S-up])
(if (equal "xterm" (tty-type))
    (define-key input-decode-map "\e[1;2A" [S-up]))
(defadvice terminal-init-xterm (after select-shift-up activate)
  (define-key input-decode-map "\e[1;2A" [S-up]))

;;; PACKAGE MODE ACTIVATION

(ac-config-default)
(auto-complete-mode t) ;auto-complete
(global-flycheck-mode t) ; error checking
(global-hungry-delete-mode t) ; deletes all white spaces
(yas-global-mode 1)
(which-key-mode t)
(multiple-cursors-mode t)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-display-style 'fancy)

(require 'auto-complete-config)
(ac-config-default)
(define-key ac-mode-map (kbd "TAB") nil)
(define-key ac-completing-map (kbd "TAB") nil)


;;; GENERAL PURPOSE KEYBINDING

(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-x z") 'suspend-emacs)
(global-set-key (kbd "M-c") 'switch-to-prev-buffer)
(global-set-key (kbd "M-#") 'comment-region)
(global-set-key (kbd "C-x C-x") 'save-buffers-kill-emacs)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-f") 'isearch-forward)
(global-set-key (kbd "M-]") 'enlarge-window)


;;; NEOTREE, FIND FILE, SWITCH BUFFER

(global-set-key (kbd "C-q") 'neotree-toggle)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-x f") 'swiper)



;;; MULTIPLE CURSOR, EXPAND REGION

(global-set-key (kbd "C-x =") 'er/expand-region)
(global-set-key (kbd "C-x l") 'mc/edit-lines)
(global-set-key (kbd "C-x .") 'mc/mark-next-like-this)
(global-set-key (kbd "C-x ,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-x a") 'mc/mark-all-like-t)

(font-lock-add-keywords 'python-mode
    '(("\\<[\\+-]?[0-9]+\\(.[0-9]+\\)?\\>" 0 'font-lock-constant-face) 
      ("\\([][{}()~^<>:=,.\\+*/%-]\\)" 1 'font-lock-negation-char-face)
      ("\\<\\([a-zA-Z_]*\\)\\s-*\(" 1 'font-lock-function-name-face)))

;;; ORG MODE
(setq org-src-fontify-natively t)
(add-hook 'org-mode-hook
	    (lambda ()
	      (setq flyspell-mode 1)
	      (toggle-truncate-lines -1)))


;;; TERM MODE : enable mouse support when using the terminal

(add-hook 'term-mode
	  (lambda ()
	    (setq xterm-mouse-mode t)))
(eval-after-load 'term-mode
  '((define-key [mouse-4] (lambda ()(interactive) '(scroll-down 1)))
    (define-key [mouse-5] (lambda ()(interactive) '(scroll-up 1)))))
;; split the window in two only when in terminal

(defun my-term ()
 (interactive)
 (term "/bin/bash"))
(global-set-key (kbd "M-r") 'my-term)



;;; C-MODE

;; fix indentation style
(setq c-default-style "linux"c-basic-offset 4)
(c-set-offset 'inexpr-class 0)

(font-lock-add-keywords
 'c-momode-alist '("\\.php?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js?\\'" . js2-mode))

(font-lock-add-keywords 'css-mode
  '(("\\([[:alpha:]-]+\\)[^: ]?:" 1 font-lock-preprocessor-face) ; selectors
    ("^[ \t]*\\([.].+\\)$" 1 font-lock-keyword-face) ; selectors
    (":\\([ .a-zA-Z0-9]*[[:alpha:]][^,;{]*\\)" 1 font-lock-negation-char-face) ; values after semi colon
    ("\\([ #a-zA-Z]*[[:alpha:]][^,{]*\\)" 1 compilation-warning-face) ; id, class, tags
    ("\\([:,\\*%]\\)" 1 'font-lock-builtin-face))); misc


;;; Commentary:
(provide '.emacs)
;;; .emacs ends here
