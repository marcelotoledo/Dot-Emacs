;; mac
(setq mac-command-modifier 'meta)

;; font
;; (set-face-attribute 'default nil
;;                    :family "inconsolata" :height 150)

(set-default-font "-apple-Inconsolata-light-normal-normal-*-15-*-*-*-m-0-iso10646-1")

;; window/frame size position
(set-frame-position (selected-frame) 0 20)
(set-frame-size (selected-frame) 100 30)
;;(set-frame-parameter nil 'fullscreen 'fullboth)
(defvar my-fullscreen-p t "Check if fullscreen is on or off")
(defvar my-darkroom-p t "Check if darkroom-mode is on or off")

;;
(setq name "Marcelo Toledo")
(setq email "marcelo@marcelotoledo.com")

;;(setq user-login-name name)
(setq user-full-name name)
(setq user-mail-address email)

;; Color Themes
(add-to-list 'load-path "~/.emacs.d/marcelo/color-theme")
(require 'color-theme)
(color-theme-initialize)
(color-theme-comidia)

;; license
(add-to-list 'load-path "~/.emacs.d/marcelo/license")
(require 'license)

;; darkroom-mode
(add-to-list 'load-path "~/.emacs.d/marcelo/darkroom-mode")
(require 'darkroom-mode)

;; flymake haml
;;(require 'flymake-haml)
(add-hook 'haml-mode-hook 'flymake-haml-load)

;; flymake ruby
;;(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)

;; rinari
(add-hook 'haml-mode-hook 'rinari-minor-mode)
(add-hook 'html-mode-hook 'rinari-minor-mode)

;; yas
(add-to-list 'load-path
              "~/.emacs.d/marcelo/yasnippet")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/global-mode 1)

;; erc
(erc-autojoin-mode 1)
(setq erc-autojoin-channels-alist
          '(("freenode.net" "#channel")
            ("oftc.net" "#channel")))

(setq erc-user-full-name "your name")
(setq erc-email-userid "your@email.com")

(require 'erc-match)
(setq erc-keywords '("nickname"))
(erc-match-mode)

(add-hook 'erc-after-connect '(lambda (irc.oftc.net mtoledo)
                                (erc-message "PRIVMSG" "NickServ identify yourpassword")))

;; desliga highlight na linha
;;(global-hl-line-mode -1)
;;(remove-hook 'coding-hook 'turn-on-hl-line-mode)
;; desliga idle highlight
;;(remove-hook 'coding-hook 'idle-highlight)
;;(global-hl-line-unhighlight)
;;(remove-hook 'pre-command-hook 'hl-line-unhighlight-now)
(remove-hook 'prog-mode-hook 'esk-turn-on-idle-highlight-mode)
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)

;; define alguns key bindings
(global-set-key (kbd "ESC ESC") 'goto-line)
(global-set-key (kbd "<M-f1>") 'undo)
(global-set-key (kbd "<M-f3>") 'call-last-kbd-macro)
(global-set-key (kbd "<M-f4>") 'my-erc)
(global-set-key (kbd "<M-f5>") 'calendar)
(global-set-key (kbd "<M-f11>") 'my-toggle-darkroom)
(global-set-key (kbd "<M-f12>") 'my-toggle-fullscreen)
;;(global-set-key (kbd "<M-f12>") 'reload-emacs)
;;(global-set-key (kbd "C-c e") 'eshell)
(global-set-key (kbd "C-c c") 'calculator)
(global-set-key (kbd "C-c s") '(lambda ()
                                 (interactive)
                                 (switch-to-buffer "*scratch*")))

;;(global-set-key (kbd "<next>") 'my-buf-next-buffer)
;;(global-set-key (kbd "<prior>") 'my-buf-prev-buffer)
(global-set-key (kbd "<C-up>") 'my-buf-next-buffer)
(global-set-key (kbd "<C-down>") 'my-buf-prev-buffer)
;;(global-set-key (kbd "<end>") 'kill-buffer-not-scratch)
;;(global-set-key (kbd "<home>") 'other-window)
(global-set-key (kbd "M-o") 'other-window)

;; increase or decrease text
(define-key global-map (kbd "M-+") 'text-scale-increase)
(define-key global-map (kbd "M--") 'text-scale-decrease)

(defun my-buf-ignore (str)
  "buffers que são ignorados"
  (or
   (string-match "\\*Buffer List\\*" str)
   (string-match "^TAGS$" str)
   (string-match "^\\*Messages\\*$" str)
   (string-match "^\\*Completions\\*$" str)
   (string-match "^\\*Compile-Log\\*$" str)
   (string-match "^\\.bbdb$" str)
   (string-match "^ " str)
   (string-match "^\\.newsrc-dribble$" str)
   (string-match "^\\*Article\\*$" str)
;;   (string-match ":INFO$" str)
   (memq str		   
	 (mapcar 
	  (lambda (x) 
	    (buffer-name 
	     (window-buffer 
	      (frame-selected-window x))))
	  (visible-frame-list)))))

(defun my-buf-next (ls)
  "Vai para o proximo buffer tirando os que estao em ignore."
  (let* ((ptr ls)
	 bf bn go)
    (while (and ptr (null go))
      (setq bf (car ptr)  bn (buffer-name bf))
      (if (null (my-buf-ignore bn))
	  (setq go bf)
	(setq ptr (cdr ptr))))
    (if go
	(switch-to-buffer go))))

(defun my-buf-prev-buffer ()
  "Vai para o buffer anterior na janela atual."
  (interactive)
  (my-buf-next (reverse (buffer-list))))

(defun my-buf-next-buffer ()
  "Vai para o proximo buffer, na janela atual."
  (interactive)
  (bury-buffer (current-buffer))
  (my-buf-next (buffer-list)))

;; rola uma linha por vez
;; scroll one line at a time (less "jumpy" than defaults)    
;;(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;;(setq scroll-step 1) ;; keyboard scroll one line at a time

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      scroll-step 1
      scroll-conservatively 1)

;; funcao para contar palavras
(defun count-words-region (begin end)
  "Print number of words in the region."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region begin end)
      (let ((step (1+ (lsh -1 -2)))
  	    (chars (- end begin))
  	    (words 0)
  	    (lines (count-lines begin end))
  	    (p begin))
  	(while (> step chars)
  	  (setq step (/ step 2)))
  	(goto-char (point-min))
  	(while (not (zerop (setq step (/ step 2))))
  	  (if (forward-word step)
  	      (progn (setq words (+ words step))
  		     (setq p (point)))
  	    (goto-char p)))
  	(message "Region contains %d character%s, %d word%s, %d line%s"
  		 chars (if (= 1 chars) "" "s")
  		 words (if (= 1 words) "" "s")
  		 lines (if (= 1 lines) "" "s"))))))

(defun my-toggle-darkroom ()
  (interactive)
  (setq my-darkroom-p (not my-darkroom-p))
  (if my-darkroom-p
      (darkroom-mode-disable)
    (darkroom-mode)))

(defun my-toggle-fullscreen ()
  (interactive)
  (setq my-fullscreen-p (not my-fullscreen-p))
  (if my-fullscreen-p
	  (restore-frame)
	(maximize-frame)))

(defun full-screen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen 
    (if (frame-parameter nil 'fullscreen)
      nil
      'fullboth)))

(defun reload-emacs ()
  (interactive)
  (set-frame-parameter nil 'fullscreen nil)
  (set-frame-parameter nil 'fullscreen 'fullboth))

(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;; tramp
(setq recentf-keep '(file-remote-p file-readable-p))

;; remove inittial text of the scratch
(setq initial-scratch-message nil)

;; exec-path
(setq exec-path (append exec-path '("/Users/marcelotoledo/.rvm/gems/ruby-1.9.2-p180/bin")))

;; mouse selection is copied to kill-ring
(setq mouse-drag-copy-region t)

;; mostrar número da coluna e linha
(setq line-number-mode    t)
(setq column-number-mode  t)
