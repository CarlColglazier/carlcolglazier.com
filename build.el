;; TODO: Probably better to install the package.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(setq package-selected-packages '(ox-hugo))
(package-refresh-contents)
(package-install-selected-packages)
(require 'ox-hugo)
(switch-to-buffer (find-file-noselect "content-org/writing.org"))
(org-hugo-export-wim-to-md :all-subtrees)
(kill-emacs)
