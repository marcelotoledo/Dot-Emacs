(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit-bindings starter-kit-eshell starter-kit-js starter-kit-ruby starter-kit-lisp maxframe flymake-ruby flymake-haml rvm)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; rvm
(rvm-use-default)

;; rinari
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)
;;(add-to-list 'rinari-major-modes 'haml-mode-hook)
;;(add-to-list 'rinari-major-modes 'html-mode-hook)

;; ido
(require 'ido)
(ido-mode t)
