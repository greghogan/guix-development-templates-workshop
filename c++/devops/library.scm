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

(use-modules
 (guix packages)
 (gnu packages)
 (gnu packages base)
 (gnu packages cmake)
 (gnu packages gcc)
 (srfi srfi-1)   ; lists
 (srfi srfi-34)  ; exceptions
 (srfi srfi-35)) ; conditions

(define (reveal-package hidden-package)
  (package
    (inherit hidden-package)
    (properties (alist-delete 'hidden? (package-properties hidden-package)))))

;; gcc packages are hidden so cannot be found with find-package-by-name
(define gcc-rewritable
  (cond ((string>=? (package-version glibc) "2.35") (reveal-package gcc-12))
        ((string>=? (package-version glibc) "2.33") (reveal-package gcc-11))
        (else (raise (condition
                      (&message (message "unknown older version of glibc")))))))

(define rewrite-package-inputs
  (package-input-rewriting/spec
   `(("cmake-minimal" . ,(const cmake))
     ("gcc" . ,(const gcc-rewritable)))))
