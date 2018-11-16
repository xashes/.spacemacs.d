;; [[file:~/org/env/dotfiles.org::*The%20list%20of%20Lisp%20packages%20required%20by%20the%20xashes-org%20layer.][The list of Lisp packages required by the xashes-org layer.:1]]
(defconst xashes-org-packages
  '((org :location built-in)
    ob-ipython
    ))
;; The list of Lisp packages required by the xashes-org layer.:1 ends here

;; [[file:~/org/env/dotfiles.org::*company][company:1]]
;; (defun xashes-org/post-init-company ()
;;   (spacemacs|add-company-backends
;;     :backends company-ob-ipython
;;     :modes ob-ipython-mode))
;; company:1 ends here

;; [[file:~/org/env/dotfiles.org::*ob-ipython][ob-ipython:1]]
(defun xashes-org/pre-init-ob-ipython ()
  (spacemacs|use-package-add-hook org
    :post-config
    (use-package ob-ipython
      :init (add-to-list 'org-babel-load-languages '(ipython . t)))))
(defun xashes-org/init-ob-ipython ())
;; ob-ipython:1 ends here

;; [[file:~/org/env/dotfiles.org::*org][org:1]]
(defun xashes-org/post-init-org ()
(with-eval-after-load 'org
  ;; Display preferences
  (setq org-ellipsis "⤵")
  (setq org-hide-emphasis-markers t)

  (setq org-confirm-babel-evaluate nil
        org-src-tab-acts-natively t)
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
  ;; (add-hook 'org-mode-hook 'org-display-inline-images)

  ;; When editing a code snippet, use the current window rather than popping open a
  ;; new one (which shows the same information).
  (setq org-src-window-setup 'current-window)
  ;; Quickly insert a block of elisp or python:
  (add-to-list 'org-structure-template-alist
               '("el" "#+BEGIN_SRC elisp\n?\n#+END_SRC"))
  (add-to-list 'org-structure-template-alist
               '("month" "#+BEGIN: clocktable :maxlevel 3 :scope agenda-with-archives :block lastmonth :formula % :link t :fileskip0\n#+END:"))
  (add-to-list 'org-structure-template-alist
               '("week" "#+BEGIN: clocktable :maxlevel 3 :scope agenda-with-archives :block lastweek :wstart 7 :formula % :link t :fileskip0\n#+END:"))
  (add-to-list 'org-structure-template-alist
               '("today" "#+BEGIN: clocktable :maxlevel 3 :scope agenda-with-archives :block today :formula % :link t :fileskip0\n#+END:"))
  (add-to-list 'org-structure-template-alist
               '("title" "#+TITLE: ?\n#+SETUPFILE: ./other/theme-bigblow.setup\n#+STARTUP: lognotereschedule\n\n"))

  ;; Task and org-capture management
  (setq org-directory "~/org")
  (setq org-brain-path "~/org/brain")

  (setq org-plantuml-jar-path
        (expand-file-name "~/plantuml.jar"))

  (defun org-file-path (directory filename)
    "Return the absolute address of an org file, given its relative name."
    (concat (file-name-as-directory directory) filename)
    )

  (setq org-index-file (org-file-path org-directory "index.org"))

  ;; Derive my agenda from org-index-file, where all my todos are in.
  (setq org-agenda-files org-index-file)

  ;; Capturing tasks
  (setq org-capture-templates
        '(
          ("j" "Journal"
           entry
           (file+olp+datetree "~/org/personal/journal.org")
           "* %?%^g\n\tCaptured %U")

          ("s" "Steps"
           entry
           (file+olp+datetree "~/org/personal/tinysteps.org")
           "* %?\n\tCaptured %U")

          ("t" "Trade Journal"
           entry
           (file+olp+datetree "~/org/trade/journal.org")
           "* %?\n\tCaptured %U")

          ("w" "Stock Watching List"
           entry
           (file+headline "~/org/trade/stock_profile.org" "Inbox")
           "* %?\n\tCaptured %U")

          ("n" "Note"
           entry
           (file "~/org/personal/note.org")
           "* %?\n\tCaptured %U")

          ("r" "Reading"
           entry
           (file+headline "~/org/personal/reading.org" "Inbox")
           "* %?\n\tCaptured %U")

          ("v" "Review"
           entry
           (file+olp+datetree "~/org/personal/review.org")
           "* %?\n\tCaptured %U")

          ("b" "Brain" plain (function org-brain-goto-end)
           "* %i%?" :empty-lines 1)

          ("g" "GTD"
           entry
           (file+headline "~/org/personal/gtd.org" "Inbox")
           "* %?\n\tCaptured %U\n \t%a")))

  (add-hook 'org-capture-mode-hook 'evil-insert-state)

  ;; Refiling
  (setq org-refile-targets (quote ((nil :maxlevel . 3)
                                   (org-agenda-files :maxlevel . 3))))

  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)

  ;; custom agenda view
  (setq org-agenda-custom-commands
        '(("i" "Tasks Focus Now"
           ((agenda "")
            (tags "URGENT")
            (todo "NEXT")
            (todo "REST")
            (todo "DOING")))
          ("o" "Agenda and Office-related tasks"
           ((agenda "")
            (todo "work")
            (tags "office")))))

  ;; 自动换行
  (add-hook 'org-mode-hook
            (lambda () (setq truncate-lines nil)))

  ;; log
  (setq org-log-into-drawer t)

  ;; clock
  (setq spaceline-org-clock-p t)

  ;; Not show further repetitions
  (setq org-agenda-repeating-timestamp-show-all nil)

  ;; Publish
  ;; (setq org-publish-project-alist
  ;;       '(("orgfiles"
  ;;           :base-directory "~/org/personal/"
  ;;           :base-extension "org\\|md"
  ;;           :publishing-directory "~/org/personal_publish/"
  ;;           :publishing-function org-html-publish-to-html
  ;;           :exclude "login.org"   ;; regexp
  ;;           :headline-levels 3
  ;;           :section-numbers nil
  ;;           :with-toc nil
  ;;           :auto-sitemap t
  ;;           :sitemap-title "Sitemap"
  ;;           :recursive t
  ;;           :html-preamble t)

  ;;         ("images"
  ;;           :base-directory "~/org/personal/images/"
  ;;           :base-extension "jpg\\|gif\\|png"
  ;;           :publishing-directory "~/org/personal_publish/images/"
  ;;           :publishing-function org-publish-attachment)

  ;;         ("other"
  ;;           :base-directory "~/org/personal/other/"
  ;;           :base-extension "css\\|el\\|setup"
  ;;           :publishing-directory "~/org/personal_publish/other/"
  ;;           :publishing-function org-publish-attachment)
  ;;         ("website" :components ("orgfiles" "images" "other"))))
  )
  )
;; org:1 ends here
