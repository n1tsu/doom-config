;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Augusin Thiercelin"
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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(add-hook 'after-init-hook 'org-roam-mode)

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

(set-face-attribute 'default nil :height 120)

(setq gnus-select-method '(nntp "news.epita.fr"))

(setq send-mail-function		'smtpmail-send-it
      message-send-mail-function	'smtpmail-send-it
      smtpmail-smtp-server		"smtp.office365.com")

(setq org-export-with-email t)

;; Org capture templates
(setq org-capture-templates
      '(("t" "Personal todo" entry
         (file+headline +org-capture-todo-file "Misc")
         "* [ ] %?
%i
%a" :prepend t)
        ("i" "Important todo" entry
         (file+headline +org-capture-todo-file "Cours")
         "* [ ] %?
%i
%a" :prepend t)
        ("n" "Personal notes" entry
         (file+headline "~/org/notes.org" "Notes")
         "* %u %?
%i
%a" :prepend t)
        ("c" "Cours communs" entry
         (file+headline "~/org/roam/cours/cours_index.org" "Communs")
         "* %?
%i
%a" :jump-to-captured t)
        ("s" "Cours SRS" entry
         (file+headline "~/org/roam/cours/cours_index.org" "SRS")
         "* %?
%i
%a" :jump-to-captured t)
        ("v" "Veille SRS" entry
         (file+headline "~/org/veille.org" "Veille SRS")
         "* [ ] %u [[%x][%?]]
%i
%a" :prepend t)
        ("m" "Veille TCOM" entry
         (file+headline "~/org/veille.org" "Veille TCOM")
         "* [ ] %u [[%x][%?]]
%i
%a" :prepend t)
        ))


;; Custom dailies templates
(setq org-roam-dailies-capture-templates
      '(("c" "cours" entry
         #'org-roam-capture--get-point
         "* %?"
         :file-name "daily/%<%Y-%m-%d>"
         :head "#+TITLE: %<%Y-%m-%d>\n"
         :olp ("Notes de cours"))

        ("m" "misc" entry
         #'org-roam-capture--get-point
         "* %?"
         :file-name "daily/%<%Y-%m-%d>"
         :head "#+TITLE: %<%Y-%m-%d>\n"
         :olp ("Notes generales"))))


;; Custom org roam capture templates
(setq org-roam-capture-templates
      '(("d" "default" plain (function org-roam-capture--get-point)
         "%?"
         :file-name "${slug}"
         :head "#+TITLE: ${title}\n
#+DATE: [%<%Y-%m-%d %j %H:%M:%S>]"
         :unnarrowed t)
        ("c" "cours" plain (function org-roam-capture--get-point)
         "%?"
         :file-name "cours/${slug}"
         :head "#+TITLE: ${title}
#+DATE: %U
#+PROFESSOR: %^{PROF|FIXME}
#+ROAM_TAGS: cours

#+INFOJS_OPT: view:info toc:nil
#+HTML_LINK_HOME: cours_index.html
#+HTML_LINK_LINK_UP: cours_index.html"
         :unnarrowed t)
        ("m" "misc" plain (function org-roam-capture--get-point)
         "%?"
         :file-name "misc/${slug}"
         :head "#+TITLE: ${title}\n
#+DATE: [%<%Y-%m-%d %j %H:%M:%S>]
#+ROAM_TAGS: misc

#+INFOJS_OPT: view:info toc:nil
#+HTML_LINK_HOME: misc_index.html
#+HTML_LINK_LINK_UP: misc_index.html'"
         :unnarrowed t)
        ))

;; Add publish project
(require 'ox-publish)
(setq org-publish-project-alist
      '(
;; Cours
      ("cours-note"
      :base-directory "~/org/roam/cours"
      :base-extension "org"
      :publishing-directory "~/cours/public_html/"
      :recursive t
;;      :auto-sitemap t
      :publishing-function org-html-publish-to-html
      :headline-levels 4             ; Just the default for this project.
      :auto-preamble t
      )
      ("cours-static"
      :base-directory "~/org/roam/cours"
      :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
      :publishing-directory "~/cours/public_html/"
      :recursive t
      :publishing-function org-publish-attachment
      )
;; Misc
      ("misc-note"
      :base-directory "~/org/roam/misc"
      :base-extension "org"
      :publishing-directory "~/misc/public_html/"
      :recursive t
;;      :auto-sitemap t
      :publishing-function org-html-publish-to-html
      :headline-levels 4             ; Just the default for this project.
      :auto-preamble t
      )
      ("misc-static"
      :base-directory "~/org/roam/misc"
      :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
      :publishing-directory "~/misc/public_html/"
      :recursive t
      :publishing-function org-publish-attachment
      )
      ("cours" :components ("cours-note" "cours-static"))
      ("misc" :components ("misc-note" "misc-static"))
      ))


;; Force pushing even if files didn't change
(setq org-publish-use-timestamps-flag 'nil)

(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
