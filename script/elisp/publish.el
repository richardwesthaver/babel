(require 'ox-publish)
(setq org-html-validation-link nil)
(setq org-html-head "
<link rel='stylesheet' type='text/css' href='https://rwest.io/css/default.css'/>")

(setq org-publish-project-alist
      '(("00-org"
	 :base-directory "~/stash/org/0x/00"
	 :publishing-directory "~/stash/public/00/org"
	 :recursive nil
	 :base-extension "org"
	 :publishing-function (org-org-publish-to-org)
	 :exclude "setup.org"
	 :auto-sitemap nil)
	("00-html"
	 :base-directory "~/stash/org/0x/00"
	 :publishing-directory "~/stash/public/00/"
	 :recursive nil
	 :base-extension "org"
	 :publishing-function (org-html-publish-to-html)
	 :exclude "setup.org"
	 :auto-sitemap nil)
	("00-pdf"
	 :base-directory "~/stash/org/0x/00"
	 :publishing-directory "~/stash/public/00/pdf"
	 :recursive nil
	 :base-extension "org"
	 :publishing-function (org-latex-publish-to-pdf)
	 :exclude "setup.org"
	 :auto-sitemap nil)

	("00-txt"
	 :base-directory "~/stash/org/0x/00"
	 :publishing-directory "~/stash/public/00/txt"
	 :recursive nil
	 :base-extension "org"
	 :publishing-function (org-ascii-publish-to-ascii)
	 :exclude "setup.org"
	 :auto-sitemap nil)
	("00/media"
	 :base-directory "~/stash/org/0x/00/media"
	 :publishing-directory "~/stash/public/00/media"
	 :base-extension "jpg\\|jpeg\\|gif\\|png\\|svg\\|webp\\|pdf\\|xml\\|json\\|ico"
	 :publishing-function org-publish-attachment)
	("00/src"
	 :base-directory "~/stash/org/0x/00/src"
	 :publishing-directory "~/stash/public/00/media"
	 :publishing-function org-publish-attachment)
	
	("all" :components ("00-org" "00-html" "00-pdf" "00-txt" "00/media" "00/src"))))
