(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 '(package-selected-packages
   '(solarized-theme yasnippet-classic-snippets yasnippet-snippets competitive-programming-snippets use-package magit auto-complete yasnippet flycheck js2-mode web-mode php-mode smartparens dracula-theme darcula-theme treemacs monokai-theme)))
(custom-set-faces
 )

;; Theme
(load-theme 'monokai t)

;; Transparency
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
(setq ispell-local-dictionary-alist
      '(("brazilian"
         "[A-ZÁÉÍÓÚÀÈÌÒÙÃÕÇÜÂÊÔa-záéíóúàèìòùãõçüâêôö]"
         "[^A-ZÁÉÍÓÚÀÈÌÒÙÃÕÇÜÂÊÔa-záéíóúàèìòùãõçüâêôö]"
         "['-]"
         nil
         ("-d" "brazilian")
         nil
         utf-8)))

(set-default 'ispell-local-dictionary "brazilian")

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

;; org-mode & Latex
(global-set-key (kbd "M-ç") 'org-latex-export-to-pdf)

