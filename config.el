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
(setq doom-font (font-spec :family "Fira Mono" :size 18 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Mono" :size 20))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-monokai-spectrum)
(setq doom-theme 'doom-palenight)

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
                            "#+TITLE: ${title}\n
#+DATE: [%<%Y-%m-%d %j %H:%M:%S>]")
         :unnarrowed t)
        ("c" "cours" plain "%?"
         :if-new (file+head "cours/${slug}.org"
                            "#+TITLE: ${title}
#+DATE: %U
#+PROFESSOR: %^{PROF|FIXME}
#+filetags: :cours:
#+INFOJS_OPT: view:info toc:nil
#+HTML_LINK_HOME: cours_index.html
#+HTML_LINK_LINK_UP: cours_index.html")
         :unnarrowed t)
        ("m" "misc" plain "%?"
         :if-new (file+head "misc/${slug}.org"
                            "#+TITLE: ${title}\n
#+DATE: [%<%Y-%m-%d %j %H:%M:%S>]
#+filetags: :misc:
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
