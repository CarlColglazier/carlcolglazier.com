;; TODO: Probably better to install the package.
(require 'ox-hugo)
(switch-to-buffer (find-file-noselect "content-org/writing.org"))
(org-hugo-export-wim-to-md :all-subtrees)
(kill-emacs)
