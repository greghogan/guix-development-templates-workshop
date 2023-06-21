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

(use-modules
 (guix packages)
 (gnu packages)
 (gnu packages base)
 (gnu packages cmake)
 (gnu packages gcc)
 (srfi srfi-34)
 (srfi srfi-35))

(define gcc-rewritable-version
  (cond ((string>=? (package-version glibc) "2.35") "12")
        ((string>=? (package-version glibc) "2.33") "11")
        (else (raise (condition
                      (&message (message "unknown older version of glibc")))))))

(define gcc-rewritable
  (car (find-packages-by-name "gcc" gcc-rewritable-version)))

(define rewrite-package-inputs
  (package-input-rewriting/spec
   `(("cmake-minimal" . ,(const cmake))
     ("gcc" . ,(const gcc-rewritable)))))
