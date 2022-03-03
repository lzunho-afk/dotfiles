(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "f5b6be56c9de9fd8bdd42e0c05fecb002dedb8f48a5f00e769370e4517dde0e8" "22f080367d0b7da6012d01a8cd672289b1debfb55a76ecdb08491181dcb29626" "79586dc4eb374231af28bbc36ba0880ed8e270249b07f814b0e6555bdcb71fab" "78e6be576f4a526d212d5f9a8798e5706990216e9be10174e3f3b015b8662e27" default))
 '(package-selected-packages
   '(solarized-theme yasnippet-classic-snippets yasnippet-snippets competitive-programming-snippets use-package magit auto-complete yasnippet flycheck js2-mode web-mode php-mode smartparens dracula-theme darcula-theme treemacs monokai-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Theme
;;(load-theme 'solarized-zenburn)
(load-theme 'monokai t)
;;(defun on-after-init ()
;;  (unless (display-graphic-p (selected-frame))
;;    (set-face-background 'default "unspecified-bg" (selected-frame))))
;;(add-hook 'window-setup-hook 'on-after-init)

;; Line numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; treemacs
(global-set-key [f8] 'treemacs)

;; Backup files
(setq backup-directory-alist `(("." . "~/.emacs.d/.files_backup")))

;; smartparens
(require 'smartparens-config)

(add-hook 'c-mode-hook 'my-smartparens-hook)
(add-hook 'c++-mode-hook 'my-smartparens-hook)
(add-hook 'java-mode-hook 'my-smartparens-hook)
(defun my-smartparens-hook ()
  (smartparens-mode))

;; webmode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

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

;; Cmd interaction (not tested)
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

