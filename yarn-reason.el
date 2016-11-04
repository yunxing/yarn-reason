;;; package --- Summary: Reason toolkit loader from yarn's sandbox

;;; Commentary:

;; Description:
;; This is a Emacs mode to be used with reason/ocaml projects installed with yarn.
;; It automatically searches the sandbox where all your dependencies are installed,
;; and picks up the installed version of:
;;  tuareg mode (for editing ocaml code),
;;  reason mode (for editing reason code),
;;  merlin (for code completion)
;; Nothing globally is required


;; Installation:
;; To get this mode to work, copy this file to the local `site-lisp' directory.
;; If you don't have permission to it, add it to a local directory and add the
;; following line to your `.emacs':
;;
;; (add-to-list 'load-path "DIR")

;; Enable the mode by:
;; (require 'yarn-reason)
;; # automatically run reason format
;; (add-hook 'reason-mode-hook (lambda ()
;;    (add-hook 'before-save-hook 'refmt-before-save)))
;;
;; In your yarn project, add the following dependencies to package.json:
;;
;; {
;;   "dependencies": {
;;     "@opam-alpha/merlin": "*",
;;     "@opam-alpha/tuareg": "*",
;;     "yarnmerlin": "*",
;;     "dependency-env": "https://github.com/npm-ml/dependency-env.git",
;;     "reason": "*"
;;   }
;; }
;; and run "yarn install --flat"
;;
;; Open any .ml or .re file inside that project, and you will have the full functionality enabled


;;; Code:
(defun find-project-root (dir)
  "Find base project directory, looking for package.json."
  (if (string= "/" dir)
      (message "not in a yarn repo.")
    (if (file-exists-p (expand-file-name "package.json" dir))
        dir
      (find-project-root (expand-file-name "../" dir)))))

(defun find-reason ()
  (when (or (string= (file-name-extension buffer-file-name) "re")
            (string= (file-name-extension buffer-file-name) "rei")
            )
    (let* ((root (find-project-root default-directory))
           (reasonpath (concat root "node_modules/reason/_build/ocamlfind/share/emacs/site-lisp")))
     (setq refmt-command (concat root "node_modules/reason/_build/ocamlfind/bin/refmt"))
      (if (file-exists-p reasonpath)
          (progn
            (add-to-list 'load-path reasonpath)
            (require 'reason-mode)
            (reason-mode)))
    )))

(defun find-tuareg ()
  (when (or (string= (file-name-extension buffer-file-name) "ml")
            (string= (file-name-extension buffer-file-name) "mli")
            )
    (let* ((root (find-project-root default-directory))
           (tuaregpath (concat root "node_modules/tuareg/")))
      (if (file-exists-p tuaregpath)
          (progn
            (add-to-list 'load-path tuaregpath)
            (require 'tuareg)
            (tuareg-mode)))
    )))

(defun find-merlin ()
  (when (or (string= (file-name-extension buffer-file-name) "re")
            (string= (file-name-extension buffer-file-name) "rei")
            (string= (file-name-extension buffer-file-name) "ml")
            (string= (file-name-extension buffer-file-name) "mli")
            )
    (let* ((root (find-project-root default-directory))
           (merlinpath (concat root "node_modules/merlin-actual/_build/ocamlfind/share/emacs/site-lisp")))
     (setq merlin-command (concat root "node_modules/.bin/yarnmerlin"))
      ;; (print merlin-command)
      (if (file-exists-p merlinpath)
          (progn
            (add-to-list 'load-path merlinpath)
            (require 'merlin)
            (merlin-mode)
            (merlin-restart-process)
            ))
    )))

(add-hook 'find-file-hook 'find-merlin)
(add-hook 'find-file-hook 'find-reason)
(add-hook 'find-file-hook 'find-tuareg)
(provide 'yarn-reason)
;;; yarn-reason.el ends here
