(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 '(package-selected-packages
   '(vterm-toggle vterm python-mode smart-tabs-mode yasnippet helm-xref dap-mode lsp-mode cmake-mode htmlize helm-flyspell treemacs all-the-icons helm-projectile magit golden-ratio-scroll-screen golden-ratio helm-swoop multiple-cursors expand-region json-mode yaml-mode use-package markdown-mode zenburn-theme helm smartparens)))
(custom-set-faces
 )

;; Startup screen size
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Line Numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; Line-break
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; minibuffer history & bk files
(setq savehist-file "~./.emacs.d/local/emacs-history")
;;(savehist-mode 1)
(setq make-backup-files nil)

;; Editor font
;;(set-frame-font "Source Code Pro-11" nil t)
(set-face-attribute 'default nil :height 100)

;; Loading GUI theme
(if (display-graphic-p)
    (load-theme 'zenburn))

;; gui settings
(tool-bar-mode 1)
(menu-bar-mode 1)
(scroll-bar-mode 1)
(setq inhibit-splash-screen t)

;; Cursor style
(setq-default cursor-type 'bar)

;; Startup garbage collection
(setq gc-cons-threshold most-positive-fixnum)

;; back to 8 MiB (default 800kB)
(add-hook 'emacs-startup-hook
	  (lambda()
	    (setq gc-cons-threshold (expt  2 23))))

;; "loading" messages buffer
(setq message-log-max t)

;; vshell & external shell shortcut
(global-set-key (kbd "C-c s") 'vterm-toggle)
(defun yt/open-xfce-term ()
  "Open xfce terminal"
  (interactive)
  (shell-command (concat "xfce4-terminal "
			 "--working-directory="
			 (file-truename default-directory))))
(global-set-key (kbd "C-c S") 'yt/open-xfce-term)

;; linux-kernel coding style for c files
(setq c-default-style "linux"
      c-basic-offset 4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion & Selection config ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package smartparens
  :config
  (smartparens-global-mode 1)
  (sp-pair "(" ")" :wrap "C-(")
  (sp-pair "'" nil :actions :rem))

(use-package markdown-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-hook 'markdown-mode-hook #'auto-fill-mode)
  (set-face-attribute 'markdown-code-face nil :inherit 'org-block))

(use-package yaml-mode)
(use-package json-mode)

(use-package golden-ratio)
(use-package helm
  :config
  (require 'helm-xref)
  
  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))
  
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  
  (setq helm-M-x-fuzzy-match t)
  
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "M-l") 'helm-mini)
  
  (setq helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t)
  
  (global-set-key (kbd "C-c h o") 'helm-occur)
  (global-set-key (kbd "C-h a") 'helm-apropos)
  (setq helm-apropos-fuzzy-match t)
  (setq helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match t)

  (helm-autoresize-mode t)
  (defun pl/helm-alive-p ()
    (if (boundp 'helm-alive-p)
	(symbol-value 'helm-alive-p)))
  (add-to-list 'golden-ratio-inhibit-functions 'pl/helm-alive-p)
  (helm-mode 1)

  (defun yt/helm-copy-unmarked-to-buffer ()
    (interactive)
    (with-helm-buffer
      (helm-mark-all)
      (cl-loop for cand in (helm-marked-candidates)
	       do (with-helm-current-buffer
		    (insert cand "\n")))))
  (define-key helm-map (kbd "C-c C-i") 'helm-copy-unmarked-to-buffer)
  (setq helm-ff-guess-ffap-urls nil))

(use-package multiple-cursors
  :config
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this))

(use-package helm-swoop
  :config
  (global-set-key (kbd "<C-f1>") 'helm-swoop)
  (setq helm-multi-swoop-edit-save t)
  (setq helm-swoop-split-with-multiple-windows nil)
  (setq helm-swoop-split-direction 'split-window-vertically)
  (setq helm-swoop-speed-or-color nil))

(use-package expand-region
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package lsp-mode
  :config
  (add-hook 'c-mode-hook 'lsp)
  (add-hook 'c++-mode-hook 'lsp)
  (setq gc-cons-threshold (* 100 1024 1024)
	read-process-output-max (* 1024 1024)
	treemacs-space-between-root-nodes nil
	company-idle-delay 0.0
	company-minimum-prefix-length 1
	lsp-idle-delay 0.1)  ;; clangd is fast

  (with-eval-after-load 'lsp-mode
    (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
    (require 'dap-cpptools)
    (yas-global-mode))
  )

(use-package smart-tabs-mode
  :config
  (smart-tabs-insinuate 'c 'c++ 'java 'javascript 'python))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File Management & Rel. ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package treemacs
  :config
  (global-set-key (kbd "C-t") 'treemacs))

(use-package magit
  :config
  (global-auto-revert-mode t)
  (global-set-key (kbd "C-c m") 'magit-status))

(use-package projectile
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (helm-projectile-on)
  (require 'helm-projectile)
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  (setq projectile-switch-project-action 'projectile-dired)
  (setq projectile-remember-window-configs t )
  (setq projectile-completion-system 'helm)
  (setq projectile-switch-project-action 'helm-projectile)
  (setq projectile-project-root-files-bottom-up '(".git" ".projectile")))

;; rename current buffer-visiting file
(defun yt/rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
	(error "Buffer '%s' não se refere a um arquivo!" name)
      (let ((new-name (read-file-name "Novo nome: " filename)))
	if (get-buffer new-name)
	(error "Um Buffer chamado '%s' já existe!" new-name)
	(rename-file filename new-name 1)
	(rename-buffer new-name)
	(set-visited-file-name new-name)
	(set-buffer-modified-p nil)
	(message "Arquivo '%s' renomeado com sucesso para '%s'"
		 name (file-name-nondirectory new-name))))))

;; get full path of current buffer
(defun yt/copy-full-path-to-kill-ring ()
  "Copy buffer's full path to kill ring."
  (interactive)
  (when buffer-file-name
    (let* ((file-truename buffer-file-name))
      (kill-new file-truename))))

(defun yt/sudo-find-file (file-name)
  "'Find file' function as a root"
  (interactive "Encontrar arquivo (sudo): ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))

(defun yt/delete-this-buffer-and-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
	(buffer (current-buffer))
	(name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
	(error "Buffer '%s' não se refere a um arquivo!" name)
      (when (yes-or-no-p "Quer realmente remover esse arquivo? ")
	(delete-file filename)
	(kill-buffer buffer)
	(message "Arquivo '%s' removido com sucesso!" filename)))))

(defun yt/save-all-buffers ()
  "Save all file buffers without confirmation."
  (interactive)
  (save-some-buffers t nil)
  (message "Salvando todos os Buffers... Pronto"))

(defhydra hydra-file-management (:color red
					:hint nil)
  "
_o_ -> Abrir arquivo
_O_ -> Abrir arquivo como root
_C_ -> Copiar o caminho do arquivo para área de transferência
_r_ -> Renomear o arquivo do Buffer atual
_d_ -> deletar o arquivo do Buffer atual
_s_ -> Salvar todos os Buffers abertos
_g_ -> Abrir o magit-status"
  ("o" find-file)
  ("O" yt/sudo-find-file)
  ("C" yt/copy-full-path-to-kill-ring)
  ("r" yt/rename-current-buffer-file)
  ("d" yt/delete-this-buffer-and-file)
  ("s" yt/save-all-buffers)
  ("g" magit-status))
(global-set-key [f3] 'hydra-file-management/body)

(defun yt/open-file-manager ()
  "Show current file in OS file manager ."
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
    (w32-shell-execute "explore" (replace-regexp-in-string "/" "\\" default-directory t t)))
   ((string-equal system-type "darwin") (shell-command "open ."))
   ((string-equal system-type "gnu/linux")
    (let ((process-connection-type nil)) (start-process "" nil "xdg-open" ".")))))


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language & Spelling ;;
;;;;;;;;;;;;;;;;;;;;;;;;;
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
(add-hook 'org-mode-hook 'my-ispell-hook)
(defun my-ispell-hook ()
  (flyspell-mode))

;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode Specific ;;
;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c e") 'org-html-export-to-html)

(setq org-html-htmlize-output-type 'css)

(setq org-export-html-postamble-format
      '("pt-br" "<p class=\"author\">Escrito por <b>%a (%e) (c) MIT</b></p>
<p class=\"date\">Atualizado em %d</p>
<p class=\"creator\">Gerado por %c</p>"))
