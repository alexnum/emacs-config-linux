(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(custom-enabled-themes (quote (zeno)))
 '(custom-safe-themes
   (quote
    ("0eccc893d77f889322d6299bec0f2263bffb6d3ecc79ccef76f1a2988859419e" default)))
 '(grep-find-ignored-directories
   (quote
    ("SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules" "bower_components" "packages" "DotNetZip" "nHapi")))
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (vue-html-mode vue-mode company tide web-mode dockerfile-mode yaml-mode add-node-modules-path prettier-js jsx-mode js-auto-beautify typescript-mode go-mode zeno-theme js2-mode rjsx-mode tern tern-auto-complete dash dash-functional frame-local ov s neotree auto-complete projectile srefactor)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
    (require 'srefactor)
    (require 'srefactor-lisp)
    
    ;; OPTIONAL: ADD IT ONLY IF YOU USE C/C++. 
    (semantic-mode 1) ;; -> this is optional for Lisp
    
    (define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
    (define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
    (define-key c-mode-map (kbd "<f4>") 'projectile-find-other-file)
    (define-key c++-mode-map (kbd "<f4>") 'projectile-find-other-file)
    (global-set-key (kbd "M-RET o") 'srefactor-lisp-one-line)
    (global-set-key (kbd "M-RET m") 'srefactor-lisp-format-sexp)
    (global-set-key (kbd "M-RET d") 'srefactor-lisp-format-defun)
    (global-set-key (kbd "M-RET b") 'srefactor-lisp-format-buffer)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(global-set-key [f8] 'neotree-toggle)
(add-to-list 'load-path "~/.local/share/icons-in-terminal/") ;; If it's not already done
(add-to-list 'load-path "~/sidebar.el/")
(add-to-list 'load-path "~/.emacs.d/plugins/")
(require 'sidebar)
(require 'backup-each-save)
(global-set-key (kbd "C-x C-f") 'sidebar-open)
(global-set-key (kbd "C-x C-a") 'sidebar-buffers-open)
(setq js-indent-level 2)
(require 'auto-complete)

;;============//================
;;Habilitar auto complete por default
(global-auto-complete-mode t)

;;==============//============
 ;; Colocar Identação sem Tabs para javascript
(defun my-js-mode-hook ()
  ;;Usar espaço quando TAB for pressionado
  (setq-default tab-always-indent nil)
  ;;Não usar espaços
  (setq indent-tabs-mode nil))
(add-hook 'js-mode-hook 'my-js-mode-hook)

;; Formatar jsx corretamente
(setq web-mode-content-types-alist
  '(("jsx" . "\\.js[x]?\\'")))
(defun web-mode-init-hook ()
  "Hooks for Web mode.  Adjust indent."
  (setq-default indent-tabs-mode nil)
  (setq web-mode-markup-indent-offset 2))
  
(add-hook 'web-mode-hook  'web-mode-init-hook)

;;React Prettier
(defun web-mode-init-prettier-hook ()
  (add-node-modules-path)
  (prettier-js-mode))

(add-hook 'web-mode-hook  'web-mode-init-hook)


;;==============//TypeScript================
 ;; Colocar Identação sem Tabs para javascript
(defun my-ts-mode-hook ()
  ;;Usar espaço quando TAB for pressionado
  (setq-default tab-always-indent nil)
  ;;Não usar espaços
  (setq indent-tabs-mode nil))
(add-hook 'typescript-mode-hook 'my-ts-mode-hook)



;;================//C++================
(defun my-c-mode-common-hook ()
       ;; my customizations for all of c-mode and related modes
       (define-key my-c-mode-common-hook-map (kbd "<f4>") 'projectile-find-other-file)
       )
     (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;=================//==============
;; Ajustes para Golang
(defun my-go-mode-hook ()
  ; Call Gofmt before saving                                                    
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding                                                      
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)

(defun auto-complete-for-go ()
(auto-complete-mode 1))
 (add-hook 'go-mode-hook 'auto-complete-for-go)

(with-eval-after-load 'go-mode
   (require 'go-autocomplete))

;;==================//=============
;;Remover trailing whitespace depois de salvar
(add-hook 'before-save-hook
          (when '(not fundamental-mode))
             'delete-trailing-whitespace)

;;rjsx-mode para pasta components
(add-to-list 'auto-mode-alist '("components\/.*\.js\'" . rjsx-mode))
(defun my-rsxj-hook ()                                                    
  (setq js-indent-level 4)
  (setq sgml-basic-offset 4)
  (setq rjsx-basic-offset 4)
  )
(add-hook 'rjsx-mode-hook 'my-rsxj-hook)

;;typescript
;;rjsx-mode para pasta components
(defun my-typescript-hook ()                                                    
  (setq js-indent-level 4)
  (setq typescript-indent-level 4)
 )
(add-hook 'typescript-mode-hook 'my-typescript-hook)

;;Não usar tab no modo HTML
(add-hook 'html-mode-hook
          (lambda()
            (setq sgml-basic-offset 2)
            (setq indent-tabs-mode t)))

;;Não usar tab no modo WEB

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq js-indent-level 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

(setq backup-directory-alist `(("." . "~/.saves")))
(add-hook 'after-save-hook 'backup-each-save)
(tool-bar-mode -1)

;;tern-js
(add-to-list 'load-path "/home/axius/.emacs.d/tern/emacs")
(autoload 'tern-mode "tern.el" nil t)

(add-hook 'js-mode-hook (lambda () (tern-mode t)))


;;typescript-tide
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)


(add-hook 'after-init-hook 'global-company-mode)


(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
;;(flycheck-add-mode 'typescript-tslint 'web-mode)
