(use-package org
  :ensure t
  :init
			       
  (setq org-refile-targets '(
			     ("~/org/beorg/inbox.org" :maxlevel . 2)
			     ("~/org/beorg/future.org" :maxlevel . 2)
                             ("~/org/pages/projects.org" :maxlevel . 2)
			     ("~/org/pages/areas.org" :maxlevel . 2)
			     ("~/org/pages/reading.org" :maxlevel . 2)
			     ("~/org/pages/resources.org" :maxlevel . 2)
			     ("~/org/pages/archive.org" :maxlevel . 2)
                             ))



  (defun my/get-journal-file-today (&optional visit)
    "Capture to, or optionally visit, today's journal file."
    (interactive)
    (let* (
           (curr-date-stamp (format-time-string "%Y_%m_%d.org"))
           (file-name (expand-file-name curr-date-stamp "~/org/journal/")))
      (if visit
	  (find-file file-name)
      	  (set-buffer (org-capture-target-buffer file-name)))
      (goto-char (point-max))))

  (defun my/visit-journal-file-today ()
    "Visit daily journal file." 
    (interactive)
    (my/get-journal-file-today t))

  (defun my/visit-inbox ()
    (interactive)
    (find-file "~/org/beorg/inbox.org"))

  (defun my/start-page ()
    (interactive)
    (find-file "~/org/pages/index.org"))
  
  (setq org-hide-leading-stars t) 
  (setq org-tag-alist '((:startgroup . nil)
			("@work" . ?w)("@home" . ?h)
			(:endgroup . nil)
			("@note" . ?o)("@next" . ?n)("@urgent" . ?u)
			))
  (setq org-feed-alist
	'(("Krebs"
	   "https://krebsonsecurity.com/feed/"
	   "~/org/feeds.org" "Krebs on Security")
	  ("Bleeping Computer"
	   "https://www.bleepingcomputer.com/feed/"
	   "~/org/feeds.org" "Bleeping Computer")))

  (setq org-capture-templates
	'(("t" "Inbox TODO"
	   entry (file+headline "~/org/beorg/inbox.org" "Todo")
	   "* TODO %?  %^G\n  SCHEDULED: %t"
	   :empty-lines 1)
          ("b" "Book"
           entry (file "~/org/pages/reading.org")
           "* %^{TITLE} %^{AUTHOR}p %^{PUBLISHED}p %^{PAGES|Unspec}p %^{RATING}p"
           :empty-lines 1)
	  ("J" "Journal TODO"
	   entry (function my/get-journal-file-today)
	   "* TODO %?  %^g\n  SCHEDULED: %t\n  --Entered on %U\n  %i\n  %a"
	   :empty-lines 1)
	  ("j" "Daily Journal Entry"
	   entry (function my/get-journal-file-today)
	   "* %? \n  --Entered on %U\n %i\n  %a"
	   :empty-lines 1)
	  ))

  
  (defun org-dtp-open (record-location)
    "Visit the dtp message with the given Message-ID."
    (shell-command (concat "open x-devonthink-item:" record-location)))
  

  :bind (("C-c l" . org-store-link)
	 ("C-c c" . org-capture)
	 ("C-c a" . org-agenda)
	 ("C-c o S" . org-save-all-org-buffers)
	 ("C-c p j" . my/visit-journal-file-today)
	 ("C-c p i" . my/visit-inbox)
	 ("C-c p s" . my/start-page)
	 ("C-c o p" . org-property-action))
  :config
    (setq org-startup-indented t)
    (setq org-log-done t)
    (setq org-skip-scheduled-if-done t)
    (setq org-agenda-skip-scheduled-if-deadline-is-shown t)
    (setq org-agenda-files (list "~/org/pages/" "~/org/beorg/" "~/org/journal/"))
    (org-add-link-type "x-devonthink-item" 'org-dtp-open)
    )


(use-package org-superstar
  :ensure t
  :after org
  :hook (org-mode . org-superstar-mode))


