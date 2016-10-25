Description:

This is a Emacs mode to be used with reason/ocaml projects installed with yarn.
It automatically searches the sandbox where all your dependencies are installed,
and picks up the installed version of:
 tuareg mode (for editing ocaml code),
 reason mode (for editing reason code),
 merlin (for code completion)
Nothing globally is required

allation:
To get this mode to work, copy this file to the local `site-lisp' directory.
If you don't have permission to it, add it to a local directory and add the
following line to your `.emacs':
(add-to-list 'load-path "DIR")
able the mode by:
(require 'yarn-reason)
# automatically run reason format
(add-hook 'reason-mode-hook (lambda ()
   (add-hook 'before-save-hook 'refmt-before-save)))
In your yarn project, add the following dependencies to package.json:
{
  "dependencies": {
    "@opam-alpha/merlin": "*",
    "@opam-alpha/tuareg": "*",
    "yarnmerlin": "*",
    "dependency-env": "https://github.com/npm-ml/dependency-env.git",
    "reason": "*"
  }
}
and run "yarn install --flat"
Open any .ml or .re file inside that project, and you will have the full functionality enabled
