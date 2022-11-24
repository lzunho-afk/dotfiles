(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(css-comb impatient-mode emmet-mode tabbar php-mode solarized-theme yasnippet-classic-snippets yasnippet-snippets competitive-programming-snippets use-package magit auto-complete yasnippet flycheck js2-mode web-mode smartparens dracula-theme darcula-theme treemacs monokai-theme)))

;; Theme
;;(load-theme 'solarized-zenburn)
(load-theme 'monokai t)
;;(defun on-after-init ()
;;  (unless (display-graphic-p (selected-frame))
;;    (set-face-background 'default "unspecified-bg" (selected-frame))))
;;(add-hook 'window-setup-hook 'on-after-init)

;; emacsclient server 
(server-start)

;; Start the initial frame maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Start every frame maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Disable menu, tools, scrollbar, startup screen
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(setq inhibit-splash-screen t)

;; Font
(set-face-attribute 'default nil :font "Iosevka Fixed-10" )

;; Cursor
(setq-default cursor-type 'bar)

;; Minimizing gargabe collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; back to 8 MiB (default 800kB)
(add-hook 'emacs-startup-hook
	  (lambda()
	    (setq gc-cons-threshold (expt 2 23))))

;; "loading" messages buffer
(setq message-log-max t)

;; Backup files
(setq make-backup-files nil)

;; Line numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; treemacs
(global-set-key (kbd "C-t") 'treemacs)

;; Backup files
(setq backup-directory-alist `(("." . "~/.emacs.d/.files_backup")))

;; Indentation
(setq c-default-style "linux"
      c-basic-offset 4)

;; smartparens
(require 'smartparens-config)
;;
;;(add-hook 'c-mode-hook 'my-smartparens-hook)
;;(add-hook 'c++-mode-hook 'my-smartparens-hook)
;;(add-hook 'java-mode-hook 'my-smartparens-hook)
;;(defun my-smartparens-hook ()
;;  (smartparens-mode))
(use-package smartparens
  :config
  (smartparens-global-mode 1)
  )

;; webmode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(autoload 'web-mode "web-mode" "Web mode library." t)

;; emmet
(require 'emmet-mode)

;; Markdown preview
(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
	   (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
	 (current-buffer)))

;; auto-complete
(ac-config-default)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; flycheck
(global-flycheck-mode)

;; MAGIT
(use-package magit
	     :config
	     (global-set-key (kbd "C-c m") 'magit-status))

;; ispell
(with-eval-after-load "ispell"
  (setenv "LANG" "pt_BR.UTF-8")
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "pt_BR")
  
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "pt_BR")

  (setq ispell-personal-dictionary "~/.hunspell_personal")

  (unless (file-exists-p ispell-personal-dictionary)
    (write-region "" nil ispell-personal-dictionary nil 0)))

(add-hook 'latex-mode-hook 'my-ispell-hook)
(defun my-ispell-hook ()
  (flyspell-mode))

;; Cmd interaction
(defun execute-cpp-program ()
  (interactive)
  (defvar foo)
  (setq foo (concat "g++ -lm -lcrypt -O2 -pipe -DONLINE_JUDGE " (buffer-name) " && ./a.out"))
  (shell-command foo))
(defun execute-cansi-program ()
  (interactive)
  (defvar foo)
  (setq foo (concat "gcc -lm -lcrypt -O2 -pipe -ansi -DONLINE_JUDGE " (buffer-name) " && ./a.out"))
  (shell-command foo))
(add-hook 'c-mode-common-hook
	  (lambda ()
	    (local-set-key [f5] 'execute-cansi-program)))
(add-hook 'c++-mode-hook
	  (lambda ()
	    (local-set-key [f5] 'execute-cpp-program)))

;; Latex
(global-set-key (kbd "M-ç") 'org-latex-export-to-pdf)
