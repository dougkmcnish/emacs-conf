(use-package org
  :ensure t
  :init
  (setq org-log-done t)
  (setq org-skip-scheduled-if-done t)
  (setq org-agenda-skip-scheduled-if-deadline-is-shown t)
  (setq org-agenda-files (list "~/org/"))
  (setq org-refile-targets '( ("~/org/projects.org" :maxlevel . 2)
			      ("~/org/inbox.org" :maxlevel . 2)
			      ("~/org/areas.org" :maxlevel . 2)
			      ("~/org/reading.org" :maxlevel . 2)
			      ("~/org/resources.org" :maxlevel . 2)
			      ("~/org/archive.org" :maxlevel . 2)))



  (defun my/get-journal-file-today (&optional visit)
    "Capture to, or optionally visit, today's journal file." 
    (interactive)
    (let* (
           (curr-date-stamp (format-time-string "%Y-%m.org"))
           (file-name (expand-file-name curr-date-stamp "~/org/")))
      (if visit
	  (switch-to-buffer (org-capture-target-buffer file-name))
      	  (set-buffer (org-capture-target-buffer file-name)))
      (goto-char (point-max))))

  (defun my/visit-journal-file-today ()
    "Visit daily journal file." 
    (interactive)
    (my/get-journal-file-today t))

  (defun my/visit-inbox ()
    (interactive)
    (find-file "~/org/inbox.org"))
  
  (setq org-tag-alist '((:startgroup . nil)
			("@work" . ?w)("@home" . ?h)
			(:endgroup . nil)
			("@note" . ?o)("@next" . ?n)("@urgent" . ?u)
			))

  
  (setq org-capture-templates
	'(("i" "Inbox TODO"
	   entry (file "~/org/inbox.org")
	   "* TODO %?  %^G\n  SCHEDULED: %t"
	   :empty-lines 1)
	  ("t" "Journal TODO"
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
	 ("C-c p j" . my/visit-journal-file-today)
	 ("C-c p i" . my/visit-inbox))
  :config
    (org-add-link-type "x-devonthink-item" 'org-dtp-open)
  )
