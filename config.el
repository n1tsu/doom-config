;;; -*- lexical-binding: t; -*-

(setq user-full-name "Augustin Thiercelin"
      user-mail-address "augustin.thiercelin@epita.fr")

(setq org-directory "~/org/")

(display-battery-mode 1)
(setq display-line-numbers-type t)

(set-frame-parameter (selected-frame) 'alpha '(95 . 95))
(add-to-list 'default-frame-alist '(alpha . (95 . 95)))

(require 'dired-x)
(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(map! :leader
      :desc "Go back to position before clicking link"
      "p p" #'org-mark-ring-goto)

(map! :leader
      :desc "Japanese"
      "j j" (cmd! (set-input-method "japanese"))
      :desc "Japanese Hiragana"
      "j h" (cmd! (set-input-method "japanese-hiragana"))
      :desc "Japanese Katakana"
      "j k" (cmd! (set-input-method "japanese-katakana")))

(defun book-faces (org-foreground org-background font)
  "Change org-faces"
  (interactive)

  (if (string= org-background "black")
      (setq block-background "#31314a")
    (setq block-background "LavenderBlush2"))

  (custom-set-faces!
    `(org-level-1 :inherit nil :family ,font :weight normal :slant normal :height 1.6 :foreground ,org-foreground)
    `(org-level-2 :inherit nil :family ,font :weight normal :slant italic :height 1.3 :foreground ,org-foreground)
    `(org-level-3 :inherit nil :family ,font :weight normal :slant italic :height 1.2 :foreground ,org-foreground)
    `(org-level-4 :inherit nil :family ,font :weight normal :slant italic :height 1.1 :foreground ,org-foreground)
    `(org-level-5 :inherit nil :family ,font :weight normal :slant italic :height 1.0 :foreground ,org-foreground)
    `(org-document-title :inherit nil :family ,font :height 1.8 :foreground ,org-foreground :underline nil)
    `(org-document-info :height 1.2 :slant italic)
    `(org-headline-done :family ,font :strike-through t)
    `(org-block :background ,block-background :family "Fira Mono" :height 0.7 :foreground ,org-foreground)
    `(org-block-begin-line :background nil :height 0.8 :family "sans-mono-font" :foreground "slate")
    `(org-block-end-line :background nil :height 0.8 :family "sans-mono-font" :foreground "slate")
    `(org-document-info-keyword :height 0.8 :foreground "gray")
    `(org-link :foreground ,org-foreground)
    `(org-special-keyword :family "sans-mono-font" :foreground "gray" :height 0.8)
    `(org-hide :foreground ,org-background)
    `(org-indent :inherit (org-hide fixed-pitch))
    `(org-date :family "sans-mono-font" :height 0.8)
    `(org-agenda-date :inherit nil :height 1.1)
    `(org-agenda-done :strike-through t :foreground "doc")
    `(org-ellipsis :underline nil :foreground "comment")
    `(org-tag :foreground "doc")
    `(org-table :family "serif-mono-font" :height 0.9 :background ,org-background)
    `(org-code :inherit nil :family "serif-mono-font" :foreground "comment" :height 0.9)
    `(org-meta-line :foreground "gray" :inherit org-document-info-keyword)
    `(org-drawer :foreground "gray" :inherit org-document-info-keyword)
    `(org-property-value :foreground "gray" :inherit org-document-info-keyword)
    `(variable-pitch :family ,font)
    )
  )

(defun black-theme ()
  (setq org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●"))
  (load-theme 'doom-vibrant t)
  (book-faces "white" "black" "Fira Mono")
  )

(defun white-theme ()
  (setq org-superstar-headline-bullets-list '(" "))
  (load-theme 'spacemacs-light t)
  (book-faces "black" "white" "ETBembo")
  )

(defun swap-theme ()
  "Swap dark and light theme"
  (interactive)
  (if (eq doom-theme 'doom-vibrant)
      (white-theme)
    (black-theme)
    )
  )

(setq doom-font (font-spec :family "Fira Mono" :size 20 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Mono" :size 22))

(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))

(setq theme_value (string-trim (get-string-from-file "~/.config/.theme")))
(if (string= theme_value "white")
    (white-theme)
  (black-theme))

(add-hook 'org-mode-hook (lambda ()
   "Beautify Org Checkbox Symbol"
   (push '("[ ]" .  "☐") prettify-symbols-alist)
   (push '("[X]" . "☑" ) prettify-symbols-alist)
   (push '("[-]" . "❍" ) prettify-symbols-alist)
   (prettify-symbols-mode)))

(setq visual-fill-column-width 110
      visual-fill-column-center-text t)

(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 0)))
(add-hook 'org-mode-hook 'visual-fill-column-mode)
(add-hook 'org-mode-hook 'auto-fill-mode)

(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in a
  subdirectory named as the org-buffer and insert a link to this file."
  (interactive)
  (setq path-no-ext (file-name-sans-extension buffer-file-name))
  (setq filename-no-ext (file-name-nondirectory path-no-ext))
  (setq screenshots-dir-name (concat path-no-ext "-screenshots"))
  (if (not (file-directory-p screenshots-dir-name))
      (make-directory screenshots-dir-name))
  (setq file-path
          (concat filename-no-ext "-screenshots/"
                  (format-time-string "%Y%m%d_%H%M%S.png")))
  (call-process "import" nil nil nil file-path)
  (setq caption (read-string "Caption: "))
  (insert (concat "#+CAPTION: " caption "\n"))
  (insert (concat "[[file:" file-path "]]")))

(setq org-export-with-properties t)
(setq org-latex-minted-options '(("linenos" "true") ("frame" "single")))

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
#+SETUPFILE: https://fniessen.github.io/org-html-themes/org/theme-readtheorg.setup
#+HTML_LINK_HOME: cours_index.html
#+HTML_LINK_LINK_UP: cours_index.html")
         :unnarrowed t)
        ("m" "misc" plain "%?"
         :if-new (file+head "misc/${slug}.org"
                            "#+TITLE: ${title}
#+DATE: [%<%Y-%m-%d %j %H:%M:%S>]
#+FILETAGS: :misc:
#+SETUPFILE: https://fniessen.github.io/org-html-themes/org/theme-readtheorg.setup
#+HTML_LINK_HOME: misc_index.html
#+HTML_LINK_LINK_UP: misc_index.html'")
         :unnarrowed t)))

(setq org-roam-dailies-capture-templates
      '(("c" "cours" entry "* %?"
         :if-new (file+head "daily/%<%Y-%m-%d>.org"
         "#+TITLE: %<%Y-%m-%d>\n")
         :olp ("Notes de cours"))

        ("m" "misc" entry "* %?"
         :file-name "daily/%<%Y-%m-%d>.org"
         :head "#+TITLE: %<%Y-%m-%d>\n"
         :olp ("Notes generales"))))

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

(setq org-publish-use-timestamps-flag 'nil)

(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(defun dw/org-present-prepare-slide ()
  (org-overview)
  (org-show-entry)
  (org-show-children)
  (outline-show-all))

(defun dw/org-present-hook ()
  (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                     (header-line (:height 4.5) variable-pitch)
                                     (org-document-title (:height 1.75) org-document-title)
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
  (dw/org-present-prepare-slide)
  (when (fboundp 'live-crafter-add-timestamp)
    (live-crafter-add-timestamp (substring-no-properties (org-get-heading t t t t)))))

(use-package org-present
  :bind (:map org-present-mode-keymap
         ("C-c C-j" . dw/org-present-next)
         ("C-c C-k" . dw/org-present-prev))
  :hook ((org-present-mode . dw/org-present-hook)
         (org-present-mode-quit . dw/org-present-quit-hook)))

(after! org
  (setq org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))
(add-hook 'org-mode-hook 'org-superstar-mode)

;; Multiple display configuration
(setq org-startup-indented t
      line-spacing 0.1
      org-bullets-bullet-list '(" ") ;; no bullets, needs org-bullets package
      org-ellipsis "  " ;; folding symbol
      org-pretty-entities t
      org-hide-emphasis-markers t
      org-agenda-block-separator ""
      org-fontify-whole-heading-line t
      org-fontify-done-headline t
      org-fontify-quote-and-verse-blocks t)

(add-hook 'org-mode-hook 'variable-pitch-mode)

(setq centaur-tabs-set-bar 'under)
(setq x-underline-at-descent-line t)

(map! :leader :desc "Switch to next group" "t n" #'centaur-tabs-forward-group
      :leader :desc "Switch to previous group" "t p" #'centaur-tabs-backward-group
      :leader :desc "Create a new tab" "t t" #'centaur-tabs--create-new-tab
      :leader :desc "List groups" "t g" #'centaur-tabs-counsel-switch-group
      :leader :desc "Kill this buffer" "t k" #'centaur-tabs--kill-this-buffer-dont-ask
      :leader :desc "Kill all buffers in group" "t a" #'centaur-tabs-kill-all-buffers-in-current-group
      :leader :desc "Kill all buffers in group except current" "t e" #'centaur-tabs-kill-other-buffers-in-current-group)

(setq treemacs-width 25)

(setq +mu4e-backend 'offlineimap)

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

(setq gnus-select-method '(nntp "news.cri.epita.fr"))
(setq smtpmail-smtp-server "smtp.office365.com"
      smtpmail-stream-type 'starttls
      smtpmail-smtp-service 587)

(remove-hook! 'mu4e-compose-pre-hook #'org-msg-mode)

(setq org-static-blog-publish-title "blog n1tsu")
(setq org-static-blog-publish-url "https://blog.n1tsu.com/")
(setq org-static-blog-publish-directory "~/org/blog/")
(setq org-static-blog-posts-directory "~/org/blog/posts/")
(setq org-static-blog-drafts-directory "~/org/blog/drafts/")
(setq org-static-blog-enable-tags t)
(setq org-export-with-toc nil)
(setq org-export-with-section-numbers nil)
(setq org-static-blog-use-preview t)

(setq org-static-blog-page-header
      "<meta name=\"author\" content=\"Augustin Thiercelin\">
<meta name=\"referrer\" content=\"no-referrer\">
<link href= \"static/style.css\" rel=\"stylesheet\" type=\"text/css\" />
<link rel=\"icon\" href=\"static/favicon.ico\">")

(setq org-static-blog-page-preamble
      "<div class=\"header\">
<a href=\"https://n1tsu.com\">Page principale</a> ; <a href=\"https://blog.n1tsu.com\">Index</a> ;</div>
<h1 class=\"main-title\">Cybercarnet</h1>
<div class=\"sub-body\">
")

(setq org-static-blog-page-postamble
      "</div><div class=\"love\"<center>Créé avec 💟 par GNU Emacs et 🦄 org mode</center></div>")

(setq org-static-blog-index-front-matter
      "")

(setq org-static-blog-langcode "fr")


(defun org-static-blog-post-preamble-override (post-filename)
  (concat
   "<h1 class=\"post-title\">"
   "<a href=\"" (org-static-blog-get-post-url post-filename) "\">" (org-static-blog-get-title post-filename) "</a>"
   "</h1>\n"
   "<div class=\"top-post\">"
   "<div class=\"post-date\"><" (format-time-string (org-static-blog-gettext 'date-format)
                                                   (org-static-blog-get-date post-filename))
   "></div>"
   "<div class=\"taglist\">" (org-static-blog-post-taglist post-filename) "</div></div>"))

(defun org-static-blog-post-postamble-override (post-filename)
  (if (string= org-static-blog-post-comments "")
      ""
    (concat "\n<div id=\"comments\">"
            org-static-blog-post-comments
            "</div>")))

(defun org-static-blog-get-preview-override (post-filename)
  (with-temp-buffer
    (insert-file-contents (org-static-blog-matching-publish-filename post-filename))
    (let ((post-title (org-static-blog-get-title post-filename))
          (post-date (org-static-blog-get-date post-filename))
          (post-taglist (org-static-blog-post-taglist post-filename))
          (post-ellipsis "")
          (preview-region (org-static-blog--preview-region)))
      (when (and preview-region (search-forward "<p>" nil t))
        (setq post-ellipsis
              (concat (when org-static-blog-preview-link-p
                        (format "<a href=\"%s\">"
                                (org-static-blog-get-post-url post-filename)))
                      org-static-blog-preview-ellipsis
                      (when org-static-blog-preview-link-p "</a>\n"))))
      ;; Put the substrings together.
      (let ((title-link
             (format "<h2 class=\"post-title\"><a href=\"%s\">%s</a></h2>"
                     (org-static-blog-get-post-url post-filename) post-title))
            (date-link
             (format-time-string (concat "<div class=\"post-date\"><"
                                         (org-static-blog-gettext 'date-format)
                                         "></div>")
                                 post-date)))
        (concat title-link "<div class=\"top-post\">" date-link
         (format "<div class=\"taglist\">%s</div>" post-taglist)
         "</div>"
         preview-region
         post-ellipsis)))))

(defun org-static-blog-post-taglist-override (post-filename)
  (let ((taglist-content "")
        (tags (remove org-static-blog-rss-excluded-tag
                      (org-static-blog-get-tags post-filename))))
    (when (and tags org-static-blog-enable-tags)
      (dolist (tag tags)
        (setq taglist-content (concat taglist-content "<a href=\""
                                      (org-static-blog-get-absolute-url (concat "tag-" (downcase tag) ".html"))
                                      "\">:" tag ":</a> "))))
    taglist-content))

(advice-add  'org-static-blog-post-preamble :override #'org-static-blog-post-preamble-override)
(advice-add  'org-static-blog-post-postamble :override #'org-static-blog-post-postamble-override)
(advice-add  'org-static-blog-get-preview :override #'org-static-blog-get-preview-override)
(advice-add  'org-static-blog-post-taglist :override #'org-static-blog-post-taglist-override)
