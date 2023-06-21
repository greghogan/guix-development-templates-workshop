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

(include "library.scm")

(use-modules
 ((guix licenses) #:prefix license:)
 (guix gexp)
 (guix git-download)
 (guix build-system cmake)
 (gnu packages llvm)
 (gnu packages ninja))

(define development-templates-c++
  (rewrite-package-inputs
    (package
      (name "development-templates-c++")
      (version "20230621")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/greghogan/guix-development-templates")
                      (commit version)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1rcip8g50w9vlmqsbvq3w09xwqpfj1s6nk6wrd8ifhyd9prwi8xk"))))
      (build-system cmake-build-system)
      (arguments
       (list
        #:configure-flags #~(list "-GNinja")
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'enter-project-directory
              (lambda _
                (chdir "c++")))
            (replace 'build
              (lambda _
                (invoke "ninja" "-j" (number->string (parallel-job-count)))))
            (replace 'check
              (lambda* (#:key tests? #:allow-other-keys)
                (when tests?
                  (setenv "CTEST_OUTPUT_ON_FAILURE" "1")
                  (invoke "ctest" "."))))
            (replace 'install
              (lambda _
                (invoke "ninja" "install"))))))
      (native-inputs
       (list clang-toolchain-15 ninja))
      (home-page "https://github.com/greghogan/guix-development-templates")
      (synopsis "Exemplar C++ project demonstrating container-based development")
      (description
       "This simple \"hello world\" project demonstrates
@itemize @bullet
@item
a Linux container built with GNU Guix
@item
compiling with clang or gcc
@item
building with make or ninja
@item
source code linting with clang format and tidy
@item
GitHub actions continuous integration workflow
@end itemize")
      (license license:asl2.0))))

(packages->manifest
 `(,development-templates-c++))
