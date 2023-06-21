;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

;; The following set of packages should be sufficient for development using
;; either gcc or clang, make or ninja, and gdb or lldb. Also included are
;; command-line utilities for use by a developer in an interactive shell.

(include "library.scm")
(include "package.scm")

(use-modules
 (guix packages)
 (gnu packages base)
 (gnu packages version-control))

(define custom-utf8-locales
  (make-glibc-utf8-locales
   glibc
   #:locales (list "en_US")
   #:name "custom-utf8-locales"))

;; clang-toolchain (as configured and compiled) can only be installed with the
;; version of gcc-toolchain used to compile clang/llvm. This typically restricts
;; gcc to a version several years old, but can be accessed by loading the
;; "(gnu packages commencement)" module and referencing ",gcc-toolchain" in the
;; packages->manifest.
;;
;; A newer version of gcc can be included using package rewriting on
;; clang-toolchain as done here. This does not always permit use of the newest
;; gcc; for example, in Guix 1.4.0 we can build with gcc@11 but glibc@2.33 fails
;; when building with gcc@12. Including the newer glibc@2.35 for core-updates is
;; not possible since package rewriting cannot be performed with an inferior,
;; and rewriting with glibc looks to simply be too large a modification and
;; results in out-of-memory errors when copying the package definition locally.
;;
;; The newest supported version of gcc for compiling glibc can be found in the
;; "Recommended Tools for Compilation" section for the appropriate version at
;; https://sourceware.org/git/?p=glibc.git;f=INSTALL;hb=refs/tags/glibc-2.35

(concatenate-manifests
 (list
  (package->development-manifest
   development-templates-c++)
  (specifications->manifest
   '(;; Packages for interactive user access.
     "gdb"
     "git"
     "less"
     #| lldb |#
     "nss-certs"
     "vim"

     ;; Packages supporting IDEs.
     "openssh"
     "rsync"
     "which"))
  (packages->manifest
   `(,custom-utf8-locales
     ,(rewrite-package-inputs lldb)))))
