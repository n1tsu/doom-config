;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Augustin Thiercelin"
      user-mail-address "augustin.thiercelin@epita.fr")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Fira Mono" :size 20 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Mono" :size 22))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-monokai-spectrum)
;;(setq doom-theme 'doom-solarized-light)
;;(setq doom-theme 'doom-palenight)
(setq doom-theme 'doom-vibrant)
;;(setq doom-theme 'spacemacs-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;;;;;;;;;;;;;
;; PERSONAL ;;
;;;;;;;;;;;;;;

;;;;;;;;;
;; ORG ;;
;;;;;;;;;

;; Org prettify checkbox
(add-hook 'org-mode-hook (lambda ()
   "Beautify Org Checkbox Symbol"
   (push '("[ ]" .  "☐") prettify-symbols-alist)
   (push '("[X]" . "☑" ) prettify-symbols-alist)
   (push '("[-]" . "❍" ) prettify-symbols-alist)
   (prettify-symbols-mode)))

;; Export properties
(setq org-export-with-properties t)

;; Org capture templates
(setq org-capture-templates
      ;; Create new entry in org/todo.org in corresponding section
      '(("t" "Personal todo" entry
         (file+headline +org-capture-todo-file "MISC")
         "* [ ] %?\n%i\n%a"
         :prepend t)
        ("i" "SRS todo" entry
         (file+headline +org-capture-todo-file "SRS")
         "* [ ] %?\n%i\n%a"
         :prepend t)
        ("a" "ACU todo" entry
         (file+headline +org-capture-todo-file "ACU")
         "* [ ] %?\n%i\n%a"
         :prepend t)
        ("p" "PROLOGIN todo" entry
         (file+headline +org-capture-todo-file "PROLOGIN")
         "* [ ] %?\n%i\n%a"
         :prepend t)
        ;; Create new entry in org/notes.org
        ("n" "Personal notes" entry
         (file+headline "~/org/notes.org" "Notes")
         "* %u %?\n%i\n%a"
         :prepend t)
        ;; Add new entry in org/roam/cours/cours_index.org
        ("c" "Cours communs" entry
         (file+headline "~/org/roam/cours/cours_index.org" "Communs")
         "* %?\n%i\n%a"
         :jump-to-captured t)
        ("s" "Cours SRS" entry
         (file+headline "~/org/roam/cours/cours_index.org" "SRS")
         "* %?\n%i\n%a"
         :jump-to-captured t)
        ;; Add new entry in org/veille.org with clipboard
        ("v" "Veille SRS" entry
         (file+headline "~/org/veille.org" "Veille SRS")
         "* [ ] %u [[%x][%?]]\n%i\n%a"
         :prepend t)
        ("m" "Veille TCOM" entry
         (file+headline "~/org/veille.org" "Veille TCOM")
         "* [ ] %u [[%x][%?]]\n%i\n%a"
         :prepend t)))



;;;;;;;;;;;;;;
;; ORG-ROAM ;;
;;;;;;;;;;;;;;

;; org roam configuration
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (file-truename "~/org/roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-setup))

;; Custom org roam capture templates
(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :if-new (file+head "${slug}.org"
                            "#+TITLE: ${title}
#+DATE: [%<%Y-%m-%d %j %H:%M:%S>]")
         :unnarrowed t)
        ("c" "cours" plain "%?"
         :if-new (file+head "cours/${slug}.org"
                            "#+TITLE: ${title}
#+DATE: %U
#+PROFESSOR: %^{PROF|FIXME}
#+FILETAGS: :cours:
#+INFOJS_OPT: view:info toc:nil
#+HTML_LINK_HOME: cours_index.html
#+HTML_LINK_LINK_UP: cours_index.html")
         :unnarrowed t)
        ("m" "misc" plain "%?"
         :if-new (file+head "misc/${slug}.org"
                            "#+TITLE: ${title}
#+DATE: [%<%Y-%m-%d %j %H:%M:%S>]
#+FILETAGS: :misc:
#+INFOJS_OPT: view:info toc:nil
#+HTML_LINK_HOME: misc_index.html
#+HTML_LINK_LINK_UP: misc_index.html'")
         :unnarrowed t)))

;; Custom dailies templates
(setq org-roam-dailies-capture-templates
      '(("c" "cours" entry "* %?"
         :if-new (file+head "daily/%<%Y-%m-%d>.org"
         "#+TITLE: %<%Y-%m-%d>\n")
         :olp ("Notes de cours"))

        ("m" "misc" entry "* %?"
         :file-name "daily/%<%Y-%m-%d>.org"
         :head "#+TITLE: %<%Y-%m-%d>\n"
         :olp ("Notes generales"))))



;;;;;;;;;;;;;
;; PUBLISH ;;
;;;;;;;;;;;;;

;; Add publish project
(require 'ox-publish)
(setq org-publish-project-alist
      '(
        ("cours-note"
         :base-directory "~/org/roam/cours"
         :base-extension "org"
         :publishing-directory "~/cours/public_html/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :auto-preamble t)
        ("cours-static"
         :base-directory "~/org/roam/cours"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/cours/public_html/"
         :recursive t
         :publishing-function org-publish-attachment)
        ("misc-note"
         :base-directory "~/org/roam/misc"
         :base-extension "org"
         :publishing-directory "~/misc/public_html/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :auto-preamble t)
        ("misc-static"
         :base-directory "~/org/roam/misc"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/misc/public_html/"
         :recursive t
         :publishing-function org-publish-attachment)
        ("cours" :components ("cours-note" "cours-static"))
        ("misc" :components ("misc-note" "misc-static"))))

;; Force pushing even if files didn't change
(setq org-publish-use-timestamps-flag 'nil)

(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))



;;;;;;;;;;;;;;;;;;
;; PRESENTATION ;;
;;;;;;;;;;;;;;;;;;

; Config from https://config.daviwil.com/emacs
(defun dw/org-present-prepare-slide ()
  (org-overview)
  (org-show-entry)
  (org-show-children))

(defun dw/org-present-hook ()
  (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                     (header-line (:height 4.5) variable-pitch)
                                     (org-code (:height 1.55) org-code)
                                     (org-verbatim (:height 1.55) org-verbatim)
                                     (org-block (:height 1.25) org-block)
                                     (org-block-begin-line (:height 0.7) org-block)))
  (setq header-line-format " ")
  (org-display-inline-images)
  (dw/org-present-prepare-slide))

(defun dw/org-present-quit-hook ()
  (setq-local face-remapping-alist '((default variable-pitch default)))
  (setq header-line-format nil)
  (org-present-small)
  (org-remove-inline-images))

(defun dw/org-present-prev ()
  (interactive)
  (org-present-prev)
  (dw/org-present-prepare-slide))

(defun dw/org-present-next ()
  (interactive)
  (org-present-next)
  (dw/org-present-prepare-slide))

(use-package org-present
  :bind (:map org-present-mode-keymap
         ("C-c C-j" . dw/org-present-next)
         ("C-c C-k" . dw/org-present-prev))
  :hook ((org-present-mode . dw/org-present-hook)
         (org-present-mode-quit . dw/org-present-quit-hook)))



;;;;;;;;;;;;;;;;;;;;;;;
;; ORG CUSTOMIZATION ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Remove bullets headline
(after! org
  (setq org-superstar-headline-bullets-list '(" ")))
(add-hook 'org-mode-hook 'org-superstar-mode)

;; Multiple display configuration
(setq org-startup-indented t
      line-spacing 0.1
      org-bullets-bullet-list '(" ") ;; no bullets, needs org-bullets package
      org-ellipsis "  " ;; folding symbol
      org-pretty-entities t
      org-hide-emphasis-markers t
      ;; show actually italicized text instead of /italicized text/
      org-agenda-block-separator ""
      org-fontify-whole-heading-line t
      org-fontify-done-headline t
      org-fontify-quote-and-verse-blocks t)

(add-hook 'org-mode-hook 'variable-pitch-mode)

(use-package! org-pretty-table
  :commands (org-pretty-table-mode global-org-pretty-table-mode))

(defun book-faces (org-foreground org-background font)
  "Change org-faces"
  (interactive)
  ;; https://lepisma.xyz/2017/10/28/ricing-org-mode/
  (custom-set-faces!
    `(org-document-title
      :inherit nil
      :family ,font
      :height 1.8
      :foreground ,org-foreground
      :underline nil)
    `(org-document-info
      :height 1.2
      :slant italic)
    `(org-level-1
      :inherit nil
      :family ,font
      :height 1.6
      :weight normal
      :slant normal
      :foreground ,org-foreground)
    `(org-level-2
      :inherit nil
      :family ,font
      :weight normal
      :height 1.3
      :slant italic
      :foreground ,org-foreground)
    `(org-level-3
      :inherit nil
      :family ,font
      :weight normal
      :slant italic
      :height 1.2
      :foreground ,org-foreground)
    `(org-level-4
      :inherit nil
      :family ,font
      :weight normal
      :slant italic
      :height 1.1
      :foreground ,org-foreground)
    `(org-level-5
      :inherit nil
      :family ,font
      :weight normal
      :slant italic
      :height 1.0
      :foreground ,org-foreground)
    `(org-headline-done
      :family ,font
      :strike-through t)
    `(org-block
      :background nil
      :family "Fira Mono"
      :height 0.7
      :foreground ,org-foreground)
    `(org-block-begin-line
      :background nil
      :height 0.8
      :family "sans-mono-font"
      :foreground "slate")
    `(org-block-end-line
      :background nil
      :height 0.8
      :family "sans-mono-font"
      :foreground "slate")
    `(org-document-info-keyword
      :height 0.8
      :foreground "gray")
    `(org-link
      :foreground ,org-foreground)
    `(org-special-keyword
      :family "sans-mono-font"
      :foreground "gray"
      :height 0.8)
    `(org-hide
      :foreground ,org-background)
    `(org-indent
      :inherit (org-hide fixed-pitch))
    `(org-date
      :family "sans-mono-font"
      :height 0.8)
    `(org-agenda-date
      :inherit nil
      :height 1.1)
    `(org-agenda-done
      :strike-through t
      :foreground "doc")
    `(org-ellipsis
      :underline nil
      :foreground "comment")
    `(org-tag
      :foreground "doc")
    `(org-table
      :family "serif-mono-font"
      :height 0.9
      :background ,org-background)
    `(org-code
      :inherit nil
      :family "serif-mono-font"
      :foreground "comment"
      :height 0.9)
    `(org-meta-line
      :foreground "gray"
      :inherit org-document-info-keyword)
    `(org-drawer
      :foreground "gray"
      :inherit org-document-info-keyword)
    `(org-property-value
      :foreground "gray"
      :inherit org-document-info-keyword)
    `(variable-pitch
      :family ,font)
    )
  )

(book-faces "white" "black" "Fira Mono")

(defun swap-theme ()
  "Swap dark and light theme"
  (interactive)
  (if (eq doom-theme 'doom-vibrant)
      (progn
        (load-theme 'spacemacs-light)
        (book-faces "black" "white" "ETBembo"))
    (progn
      (load-theme 'doom-vibrant)
      (book-faces "white" "black" "Fira Mono"))
    )
  )



;;;;;;;;;;;;;;;;;;
;; CENTAUR-TABS ;;
;;;;;;;;;;;;;;;;;;

(setq centaur-tabs-set-bar 'under)
(setq x-underline-at-descent-line t)

(map! :leader :desc "Switch to next group" "t n" #'centaur-tabs-forward-group
      :leader :desc "Switch to previous group" "t p" #'centaur-tabs-backward-group
      :leader :desc "Create a new tab" "t t" #'centaur-tabs--create-new-tab
      :leader :desc "List groups" "t g" #'centaur-tabs-counsel-switch-group
      :leader :desc "Kill this buffer" "t k" #'centaur-tabs--kill-this-buffer-dont-ask
      :leader :desc "Kill all buffers in group" "t a" #'centaur-tabs-kill-all-buffers-in-current-group
      :leader :desc "Kill all buffers in group except current" "t e" #'centaur-tabs-kill-other-buffers-in-current-group)



;;;;;;;;;;;;;;
;; TREEMACS ;;
;;;;;;;;;;;;;;

(setq treemacs-width 25)



;;;;;;;;;;;;;;;
;; MAIL/NEWS ;;
;;;;;;;;;;;;;;;

(setq +mu4e-backend 'offlineimap)

;; Les paths sont relatifs a Mu
(set-email-account! "epita.fr"
  '((mu4e-sent-folder       . "/Sent")
    (mu4e-drafts-folder     . "/Drafts")
    (mu4e-trash-folder      . "/Trash")
    (mu4e-refile-folder     . "/INBOX")
    (mu4e-compose-signature . "Augustin Thiercelin")
    (smtpmail-smtp-user     . "augustin.thiercelin@epita.fr")
    (user-mail-address      . "augustin.thiercelin@epita.fr"))
  t)

(set-variable 'read-mail-command 'mu4e)
(setq message-kill-buffer-on-exit t)
(setq mail-user-agent 'mu4e-user-agent)
(setq mu4e-compose--org-msg-toggle-next nil)
(setq mu4e-compose-signature-auto-include t)
(setq gnus-select-method '(nntp "news.epita.fr"))

(setq smtpmail-smtp-server "smtp.office365.com"
      smtpmail-stream-type 'starttls
      smtpmail-smtp-service 587)

(remove-hook! 'mu4e-compose-pre-hook #'org-msg-mode)

(display-battery-mode 1)
