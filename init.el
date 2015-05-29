(eval-when-compile
  (require 'cl))

(require 'package)

(progn
	(setq package-enable-at-startup nil)
	
	(add-to-list 'package-archives
							 '("marmalade" . "https://marmalade-repo.org/packages/"))

	(add-to-list 'package-archives
							 '("melpa" . "http://melpa.org/packages/"))

	(add-to-list 'package-archives
							 '("elpy" . "http://jorgenschaefer.github.io/packages/"))

	(package-initialize)

	(unless (package-installed-p 'req-package)
		(package-refresh-contents)
		(package-install 'req-package)))

(require 'req-package)

(req-package auctex
	:commands (tex-mode)
	:config (progn
						(setq TeX-auto-save t)
						(setq TeX-parse-self t)
						(setq-default TeX-master nil)))

(req-package company-auctex
	:require (auctex company)
	:config (progn
						(company-auctex-init)))

(req-package emacs-eclim
	:config (progn
						(eval-after-load "company" (company-emacs-eclim-setup))
						(global-eclim-mode)))

(req-package disaster
	:commands (disaster)
	:bind (("C-c d" . disaster)))

(req-package focus
	:disabled t
	:config (progn
						(add-hook 'lisp-mode-hook 'focus-mode)
						(add-hook 'emacs-lisp-mode-hook 'focus-mode)
						))

(req-package eldoc
	:config (progn
						(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)))

(req-package flycheck
	:config (progn
						(custom-set-variables
						 '(flycheck-display-errors-function 
							 #'flycheck-pos-tip-error-messages))
						
						(add-hook 'rust-mode-hook 'flycheck-mode)
						(add-hook 'enh-ruby-mode-hook 'flycheck-mode)
						(add-hook 'python-hook 'flycheck-mode)
						(add-hook 'cperl-mode-hook 'flycheck-mode)
						(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
						(add-hook 'c-mode-common-hook 'flycheck-mode)))

(req-package flycheck-pos-tip
	:require (flycheck)
	:commands (flycheck-mode))

(req-package flycheck-package
	:require (flycheck)
	:commands (flycheck-mode)
	:config (progn
						(flycheck-package-setup)))

(req-package flycheck-haskell
	:require (haskell-mode flycheck)
	:config (progn
						(add-hook 'haskell-mode-hook 'flycheck-mode)
						(add-hook 'flycheck-mode-hook 'flycheck-haskell-configure)))

(defun haskell-config/setup-company ()
  (interactive)
  (make-variable-buffer-local 'company-backends)
  (setq-local company-backends '(company-ghci))
  (company-mode t))

(req-package company-ghci
	:require (haskell-mode
						company)
	:config (progn
						(add-hook 'haskell-mode-hook 
											'haskell-config/setup-company)
						(add-hook 'haskell-interactive-mode-hook 
											'haskell-config/setup-company)))

(req-package haskell-mode
	:commands haskell-mode
	:config (progn
						(bind-key "C-c C-l" 'haskell-process-load-or-reload haskell-mode-map)
						(add-hook 'haskell-mode-hook 'turn-on-haskell-doc)
						(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
						(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
						(custom-set-variables
						 '(haskell-doc-show-global-types t)
						 '(haskell-process-type 'cabal-repl)
						 '(haskell-notify-p t)
						 '(haskell-stylish-on-save nil)
						 '(haskell-tags-on-save nil)
						 '(haskell-process-suggest-remove-import-lines t)
						 '(haskell-process-auto-import-loaded-modules t)
						 '(haskell-process-log t)
						 '(haskell-process-reload-with-fbytecode nil)
						 '(haskell-process-use-presentation-mode t)
						 '(haskell-interactive-mode-include-file-name nil)
						 '(haskell-interactive-mode-eval-pretty nil)
						 '(shm-use-presentation-mode t)
						 '(shm-auto-insert-skeletons t)
						 '(shm-auto-insert-bangs t)
						 '(haskell-process-suggest-haskell-docs-imports t)
						 '(hindent-style "chris-done")
						 '(haskell-interactive-mode-eval-mode 'haskell-mode)
						 ;; '(haskell-process-path-ghci "ghci-ng")
						 '(haskell-process-args-ghci '("-ferror-spans"))
						 '(haskell-process-generate-tags nil)
						 '(haskell-complete-module-preferred
							 '("Data.ByteString"
								 "Data.ByteString.Lazy"
								 "Data.Conduit"
								 "Data.Function"
								 "Data.List"
								 "Data.Map"
								 "Data.Maybe"
								 "Data.Monoid"
								 "Data.Ord")))))

(req-package slime
	:commands (slime lisp-mode)
	:init (progn
					(setq inferior-lisp-program "sbcl")
					(setq slime-contribs '(slime-fancy 
																 slime-company 
																 slime-highlight-edits 
																 inferior-slime)))
	:config (progn
						(add-hook 'lisp-mode-hook
											(lambda ()
												(unless (slime-connected-p)
													(save-excursion (slime)))))
						
						(add-hook 'lisp-mode-hook (lambda ()
																				(slime-mode t)))

						))

(defun cl-config/configure-company-slime ()
  (make-variable-buffer-local 'company-backends)
  (setq company-backends '()))

(req-package slime-company
	:require (slime company)
	:commands (slime slime-mode slime-repl-mode)
	:config (progn
						(add-hook 'slime-mode-hook 
											'cl-config/configure-company-slime)
						(add-hook 'slime-interactive-mode-hook 
											'cl-config/configure-company-slime)))

(req-package evil-lisp-state
	:require (evil)
	:config (progn
						(define-key evil-normal-state-map (kbd "L") 'evil-lisp-state)))

(req-package evil
	:config (progn
						(define-key evil-normal-state-map [escape] 'keyboard-quit)
						(define-key evil-visual-state-map [escape] 'keyboard-quit)
						(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
						(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
						(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
						(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
						(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
						(define-key evil-visual-state-map (kbd "TAB") 'indent-region)
						(define-key evil-normal-state-map (kbd "C-TAB") 'indent-whole-buffer)
						(define-key evil-normal-state-map [return]
							(lambda ()
								(interactive)
								(save-excursion
									(newline))))

						(define-key evil-visual-state-map (kbd ";") 'comment-dwim)

						(defadvice eval-last-sexp (around evil)
							"Last sexp ends at point."
							(when (evil-normal-state-p)
								(save-excursion
									(unless (or (eobp) (eolp)) (forward-char))
									ad-do-it)))

						(cl-loop for mode in '(haskell-interactive-mode
																	 haskell-presentation-mode
																	 haskell-error-mode
																	 inferior-emacs-lisp-mode
																	 erc-mode
																	 parparadox-menu-mode
																	 comint-mode
																	 eshell-mode
																	 slime-repl-mode
																	 slime-macroexpansion-minor-mode-hook
																	 geiser-repl-mode
																	 )
										 do (evil-set-initial-state mode 'emacs))
						
						(setf evil-move-cursor-back nil)
						(evil-mode t)))

(req-package evil-leader
	:require (evil)
	:config (progn
						(setq evil-leader/leader ",") 
						(evil-leader/set-key
							"f" 'find-file
							"b" 'switch-to-buffer
							"g" 'execute-extended-command
							"k" 'kill-buffer
							"," 'evil-execute-in-god-state
							"p" 'helm-projectile
							";" 'comment-dwim
							"e" 'eval-last-sexp
							"w" 'save-buffer
							"." 'ggtags-find-tag-dwim
							"hs" 'helm-swoop
							"ha" 'helm-ag
							"hi" 'helm-semantic-or-imenu)
						(global-evil-leader-mode)
						
						(evil-leader/set-key-for-mode 'lisp-mode "cl" 'slime-load-file)
						(evil-leader/set-key-for-mode 'lisp-mode "e" 'slime-eval-last-expression)
						(evil-leader/set-key-for-mode 'lisp-mode "me" 'slime-macroexpand-1)
						(evil-leader/set-key-for-mode 'lisp-mode "ma" 'slime-macroexpand-all)
						(evil-leader/set-key-for-mode 'lisp-mode "sds" 'slime-disassemble-symbol)
						(evil-leader/set-key-for-mode 'lisp-mode "sdd" 'slime-disassemble-definition)
						(evil-leader/set-key-for-mode 'projectile-mode (kbd "p")'helm-projectile)))

(req-package evil-god-state
	:require (evil god-mode)
	:config (progn
						(bind-key "ESC" 'evil-normal-state evil-god-state-map)))

(req-package company
	:config (progn
						(add-hook 'rust-mode-hook 'company-mode)
						(add-hook 'c-mode-common-hook 'company-mode)
						(add-hook 'emacs-lisp-mode-hook 'company-mode)
						(add-hook 'inferior-emacs-lisp-mode-hook 'company-mode)
						(add-hook 'python-hook 'company-mode)
						(setq company-idle-delay 0.5)))


(req-package irony
	:config (progn
						(add-hook 'c-mode-common-hook 'irony-mode)
						(defun my-irony-mode-hook ()
							(define-key irony-mode-map [remap completion-at-point]
								'irony-completion-at-point-async)
							(define-key irony-mode-map [remap complete-symbol]
								'irony-completion-at-point-async))
						(add-hook 'irony-mode-hook 'my-irony-mode-hook)
						(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)))

(req-package company-irony
	:require (company irony)
	:config (progn
						(add-hook 'c-mode-common-hook 
											(lambda ()
												(make-variable-buffer-local 'company-backends)
												(setq company-backends '(company-irony))))
						(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)))

(req-package irony-eldoc
	:require (irony eldoc)
	:config (progn
						(add-hook 'irony-mode-hook 'eldoc-mode)
						(add-hook 'irony-mode-hook 'irony-eldoc)))

(req-package flycheck-irony
	:require (flycheck irony)
	:config (progn
						(add-hook 'flycheck-mode-hook 'flycheck-irony-setup)))

(req-package ggtags
	:requires (cperl-mode)
	:commands (c++-mode c-mode cperl-mode)
	:config (progn
						(add-hook 'c-mode-common-hook 'ggtags-mode)))

(req-package aggressive-indent
	:config (progn
						(add-hook 'web-mode-hook 'aggressive-indent-mode)
						(add-hook 'js2-mode-hook 'aggressive-indent-mode)
						(add-hook 'cperl-mode-hook 'aggressive-indent-mode)
						(add-hook 'emacs-lisp-mode-hook 'aggressive-indent-mode)
						(add-hook 'c-mode-common-hook 'aggressive-indent-mode)))

(req-package company-c-header
	:require (company)
	:commands (company-mode))

(req-package erc
	:commands (erc start-erc)
	:config (progn
						(erc-autojoin-mode 1)
						
						(setq erc-autojoin-channels-alist
									'(("freenode.net"
										 "#emacs"
										 "#gentoo"
										 "#stumpwm"
										 "#haskell"
										 "#concatenative"
										 "#perl"
										 "#lisp"
										 "#archlinux")
										("torncity.com"
										 "#lobby"
										 "#help")
										("perl.org"
										 "#p5p")
										("rizon.io"
										 "#/r/syriancivilwar")))

						(defun start-erc ()
							(interactive)
							(erc :nick "juiko" :password "caballovolado"))
						))

(req-package factor-mode
	:load-path "/home/juiko/git/factor/misc/fuel"
	:require (fuel-mode)
	:config (progn
						(let ((root-dir "/home/juiko/git/factor"))
							(setf factor-root-dir root-dir
										fuel-listener-factor-binary (concat factor-root-dir
																												"/"
																												"factor")
										
										fuel-listener-factor-image (concat factor-root-dir
																											 "/"
																											 "factor.image")

										factor-indent-level 2))))

(req-package fuel-mode
	:load-path "/home/juiko/git/factor/misc/fuel"
	:config (progn
						(add-hook 'factor-mode-hook 'fuel-mode)))

(req-package leuven-theme
	:config (progn
						(load-theme 'leuven t)
						(set-face-attribute 'fringe
																nil
																:background "2e3436"
																:foreground "2e3436")
						(blink-cursor-mode -1)
						(menu-bar-mode -1)
						(tool-bar-mode -1)
						(scroll-bar-mode -1)

						(add-to-list 'default-frame-alist '(font . "Droid Sans Mono-9"))
						(add-to-list 'default-frame-alist '(cursor-color . "Gray"))

						(set-display-table-slot standard-display-table 
																		'vertical-border 
																		(make-glyph-code 8203))))

(req-package helm-descbinds
	:require (helm-config)
	:bind (("C-h b" . helm-descbinds)
				 ("C-h w" . helm-descbinds)))

(req-package helm-projectile
	:require (helm-config projectile)
	:config (progn
						(helm-projectile-on)))

(req-package helm-company
	:require (helm-config company)
	:commands (company-mode)
	:config (progn
						(bind-key "C--" 'helm-company company-mode-map)
						(bind-key "C--" 'helm-companycompany-active-map)))


(req-package helm-gtags
	:require (helm-config)
	:commands (helm-gtags)
	:config (progn
						(setq
						 helm-gtags-ignore-case t
						 helm-gtags-auto-update t
						 helm-gtags-use-input-at-cursor t
						 helm-gtags-pulse-at-cursor t
						 helm-gtags-prefix-key "\C-cg"
						 helm-gtags-suggested-key-mapping t)))


(req-package helm-config
	:config (progn
						(bind-key "C-h a" 'helm-apropos)
						(bind-key "C-x C-b" 'switch-to-buffer)
						(helm-mode t)))

(req-package helm-ag
	:commands (helm-ag)
	:require (helm-config))

(req-package helm-ack
	:commands (helm-ack)
	:require (helm-config)
	:ensure t
	)

(req-package helm-swoop
	:commands (helm-swoop)
	:require (helm-config)
	:ensure t
	)


(req-package magit
	:commands (magit-status magit-init magit-log)
	:defer t
	:init (progn
					(setq magit-last-seen-setup-instructions "1.4.0")))

(req-package cperl-mode
	:commands (cperl-mode)
	:init (progn
					(defalias 'perl-mode 'cperl-mode))
	:config (progn
						(add-to-list 'auto-mode-alist '("\\.t\\'" . cperl-mode))
						(add-hook 'cperl-mode-hook
											(lambda ()
												(cperl-set-style "K&R")
												(setq 
												 cperl-indent-level 2)))))

(req-package plsense
	:require (cperl-mode)
	:commands (cperl-mode)
	:config (progn
						(add-hook 'cperl-mode-hook
											'(lambda ()
												 (setq plsense-popup-help "C-c C-:")
												 (setq plsense-display-help-buffer "C-c M-:")
												 (setq plsense-jump-to-definition "C-c C->")
												 (plsense-config-default)))))

(req-package yasnippet
	:commands (yas-minor-mode)
	:init (progn
					(add-hook 'cperl-mode-hook 'yas-minor-mode)))

(req-package projectile
	:config (progn
						(setq projectile-indexing-method 'alien)
						(setq projectile-enable-caching t)
						(projectile-global-mode)))



(req-package socks
	:defer t
	:config (progn
						(setq url-proxy-services
									'(("no_proxy" . "^\\(localhost\\|10.*\\)")
										("http" . "localhost:8118")
										("https" . "localhost:8118")))))

(req-package python)

(req-package elpy
	:require (python)
	:config (progn
						(elpy-enable)))

(req-package pyvenv
	:require (python))

(req-package virtualenvwrapper
	:commands (python)
	:config (progn
						(venv-initialize-interactive-shells)
						(venv-initialize-eshell)))

(req-package enh-ruby-mode
	:mode "\\.rb\\'")

(req-package inf-ruby
	:require (enh-ruby-mode)
	:config (progn
						(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)))

(req-package robe
	:require (enh-ruby-mode)
	:config (progn
						(add-hook 'enh-ruby-mode-hook 'robe-mode)
						(add-hook 'robe-mode-hook 'ac-robe-setup)))

(req-package ruby-end
	:require (enh-ruby-mode)
	:init(progn
				 (add-hook 'enh-ruby-mode-hook 'ruby-end-mode)))

(req-package re-builder
	:defer t
	:config (progn
						(setq reb-re-syntax 'string)))

(req-package rust-mode
	:mode "\\.rs\\'")

(req-package company-racer
	:require (company rust-mode)
	:config (progn
						(custom-set-variables 
						 '(company-racer-rust-executable
							 "/home/juiko/git/racer/target/release/racer"))

						(add-hook 'rust-mode-hook
											(lambda ()
												(make-variable-buffer-local 'company-backends)
												(setq-local company-backends '(company-racer))))))

(req-package flycheck-rust
	:require (flycheck rust-mode)
	:config (progn
						(add-hook 'flycheck-mode-hook 'flycheck-rust-setup)))

(req-package geiser
	:require (company)
	:commands (scheme-mode geiser-mode)
	:config (progn
						(add-hook 'geiser-mode 'geiser-autodoc-mode)
						(add-hook 'scheme-mode 'turn-on-geiser-mode)
						(add-hook 'geiser-mode-hook 'company-mode)))

(req-package smooth-scrolling
	)

(req-package web-mode
	:commands (web-mode auto-complete)
	:init (progn
					(defalias 'html-mode 'web-mode)
					(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
					(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
					(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
					(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
					(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
					(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
					(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
					(add-to-list 'auto-mode-alist '("\\.html" . web-mode))
					)
	:config (progn
						(setq web-mode-ac-sources-alist
									'(("css" . (ac-source-css-property))
										("html" . (ac-source-words-in-buffer ac-source-abbrev))))
						))

(req-package js2-mode
	:commands (js2-mode javascript-mode)
	:init (progn
					(defalias 'javascript-mode 'js2-mode)))

(req-package ac-js2
	:require (auto-complete)
	:config (progn
						(add-hook 'js2-mode-hook 'ac-js2-mode)
						))

(req-package rainbow-mode
	:require (web-mode js2-mode)
	:mode "\\.js2\\'"
	:config (progn
						(add-hook 'web-mode-hook 'rainbow-mode)
						(add-hook 'html-mode-hook 'rainbow-mode)
						(add-hook 'css-mode-hook 'rainbow-mode)
						(add-hook 'js2-mode-hook 'rainbow-mode)))

(req-package whitespace
	:defer 5
	:config (progn
						(setq whitespace-line-column 80)
						(setq whitespace-style '(face lines-tail))
						(add-hook 'prog-mode-hook 'whitespace-mode)))

(req-package smartparens-config
	:config (progn
						(smartparens-global-strict-mode)))

(req-package smartparens-haskell
	:require (smartparens-config haskell-mode))

(req-package smartparens-python
	:require (smartparens-config python))

(req-package evil-smartparens
	:require (evil smartparens)
	:config (progn
						(add-hook 'smartparens-mode-hook #'evil-smartparens-mode)
						(evil-sp-override)))

(req-package auto-complete
	:config (progn
						(add-hook 'web-mode-hook 'auto-complete-mode)
						(add-hook 'cperl-mode-hook 
											'(lambda ()
												 (setq ac-sources
															 '(ac-source-plsense-sub
																 ac-source-plsense-constructor
																 ac-source-plsense-hash-member
																 ac-source-plsense-include
																 ac-source-plsense-list-element
																 ac-source-plsense-quoted
																 ac-source-plsense-variable
																 ac-source-plsense-word))))))



;;;;;;;;;;;;;; Personal configuration ;;;;;;;;;;;;;;;;;;;;

(add-hook 'highlight-parentheses-mode-hook
          '(lambda ()
						 (setq autopair-handle-action-fns
									 (append
										(if autopair-handle-action-fns
												autopair-handle-action-fns
											'(autopair-default-handle-action))
										'((lambda (action pair pos-before)
												(hl-paren-color-update)))))))

(run-with-idle-timer 10
                     t
                     (lambda () (ignore-errors (kill-buffer "*Buffer List*"))))



(progn
  (setq tramp-default-method "ssh")
  (show-paren-mode)
  (setq-default indent-tabs-mode t)
  (setq-default tab-width 2)
  (setq-default standard-indent 2)
  (setq-default lisp-body-indent 2)

  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
  
  (add-hook 'after-save-hook
            (lambda ()
              (let ((init-file (expand-file-name "~/.emacs.d/init.el")))
                (when (equal (buffer-file-name) init-file)
                  (byte-compile-file init-file)))))

  (setq inhibit-startup-message t)
  (global-set-key (kbd "C-<tab>") 'indent-whole-buffer)
  (global-set-key (kbd "M-_") 'hippie-expand)
  (global-set-key (kbd "C-.") 'clear-screen)
  (global-set-key (kbd "C-;") 'comment-dwim)

  (global-set-key (kbd "M-g M-g") 'goto-line-with-feedback)

  (global-set-key (kbd "M-<left>") 'enlarge-window-horizontally)
  (global-set-key (kbd "M-<down>") 'enlarge-window-vertically)
  (global-set-key (kbd "M-<right>") 'shrink-window-horizontally)
  (global-set-key (kbd "C-%") 'iedit-mode)

  (fset 'yes-or-no-p 'y-or-n-p)

  (global-auto-revert-mode 1)

  (electric-indent-mode t)

  ;; (recentf-mode t)
  (windmove-default-keybindings)

  ;; I dont like temp files
  ;; hide them !
  (setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t)))

  (setq global-auto-revert-non-file-buffers t)
  (setq auto-revert-verbose nil)

  (setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
   '(("." . "~/.emacs.d/saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t))

(put 'downcase-region 'disabled nil)

(req-package-finish)
