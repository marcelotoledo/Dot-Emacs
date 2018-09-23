(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-ag helm-descbinds geiser helm-projectile helm anaconda-mode async auctex avy company f gh git-commit ht ido-completing-read+ inf-ruby js2-mode json-mode magit-popup marshal pcache powerline rainbow-delimiters rainbow-mode rich-minority s seq with-editor yasnippet smart-mode-line-powerline-theme fiplr spaceline-all-the-icons spaceline dumb-jump sayid clojure-mode csv-mode geeknote go-mode yaml-mode automargin darkroom-mode darkroom color-theme markdown-mode vkill exec-path-from-shell zop-to-char zenburn-theme which-key volatile-highlights undo-tree smartrep smartparens operate-on-number move-text magit projectile ov imenu-anywhere guru-mode grizzl god-mode gitignore-mode gitconfig-mode git-timemachine gist flycheck expand-region epl easy-kill diminish diff-hl discover-my-major dash crux browse-kill-ring beacon anzu ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-comidia)

;; mac
(setq mac-command-modifier 'meta)

;;
(setq name "Marcelo Toledo")
(setq email "marcelo@marcelotoledo.com")

;; desliga highlight na linha
(global-hl-line-mode -1)

;; define alguns key bindings
(global-set-key (kbd "ESC ESC") 'goto-line)
(global-set-key (kbd "<M-f1>") 'undo)
(global-set-key (kbd "<M-f3>") 'call-last-kbd-macro)
;;(global-set-key (kbd "<M-f4>") 'my-erc)
(global-set-key (kbd "<M-f11>") 'darkroom-mode)
(global-set-key (kbd "<M-f12>") 'toggle-frame-maximized)
;;(global-set-key (kbd "<M-f12>") 'reload-emacs)
(global-set-key (kbd "C-c e") 'eshell)
(global-set-key (kbd "C-c c") 'calculator)
(global-set-key (kbd "C-c s") '(lambda ()
                                 (interactive)
                                 (switch-to-buffer "*scratch*")))
(global-set-key (kbd "<C-up>") 'my-buf-next-buffer)
(global-set-key (kbd "<C-down>") 'my-buf-prev-buffer)
(global-set-key (kbd "M-o") 'other-window)
(define-key global-map (kbd "M-+") 'text-scale-increase)
(define-key global-map (kbd "M--") 'text-scale-decrease)
(global-set-key (kbd "M-p") 'avy-goto-char)
(global-set-key (kbd "M-:") 'avy-goto-char-2)
(global-set-key (kbd "C-x g") 'magit-status)


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

;; remove inittial text of the scratch
(setq initial-scratch-message nil)


;; mouse selection is copied to kill-ring
(setq mouse-drag-copy-region t)

;; mostrar número da coluna e linha
(setq line-number-mode    t)
(setq column-number-mode  t)

;; woahhh
(setq prelude-whitespace nil)

;; YES to No arrow navigation in editor buffers
(setq prelude-guru nil)

;; darkroom
(require 'darkroom)

;; Desligar o scrollbar
(scroll-bar-mode -1)

;; automargin
(require 'automargin)
(when (require 'automargin nil t)
  (automargin-mode 1))

;; font
(set-frame-font "Menlo:pixelsize=18")
;;(set-face-attribute 'default nil :height 160)

;; sayid clojure
(eval-after-load 'clojure-mode
  '(sayid-setup-package))

;; geeknote
(setq geeknote-command "python /usr/local/bin/geeknote")

(global-set-key (kbd "C-c g c") 'geeknote-create)
(global-set-key (kbd "C-c g e") 'geeknote-edit)
(global-set-key (kbd "C-c g f") 'geeknote-find)
(global-set-key (kbd "C-c g s") 'geeknote-show)
(global-set-key (kbd "C-c g r") 'geeknote-remove)
(global-set-key (kbd "C-c g m") 'geeknote-move)

;; dumb-jump
(dumb-jump-mode)
