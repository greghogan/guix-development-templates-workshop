<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

This project demonstrates development and continuous integration using
[Linux Containers](https://linuxcontainers.org) specified and built with
[GNU Guix](https://guix.gnu.org).

## Reproducible development with containers

Container-based development is a powerful tool for C and C++ development, which
has long benefited from and suffered through designation as the system
programming language. While Linux distributions provide binary packages for a
tiny subset of available open source software, most C and C++ software is still
built from source (./configure && make && make install). Ad hoc software
installation clutters the developer's filesystem and has no standard for package
removal or updates, a critical step for applying security patches. This
contrasts with the container, which encapsulates in a single object an entire
filesystem and can be easily downloaded, replaced, deleted, or recreated.

Community-maintained package repositories make available binary releases for
languages including
[C and C++](https://conan.io)
[2](https://vcpkg.io),
[Go](https://pkg.go.dev),
[Haskell](https://hackage.haskell.org),
[Java](https://central.sonatype.com),
[Javascript](https://www.npmjs.com),
[Julia](https://juliapackages.com),
[Perl](https://www.cpan.org),
[PHP](https://packagist.org),
[Python](https://pypi.org),
[OCaml](https://opam.ocaml.org),
[R](https://cran.r-project.org),
[Ruby](https://rubygems.org),
[Rust](https://crates.io),
and [TeX](https://www.tug.org/texlive).
These pre-compiled binaries, though typically the primary method of software
distribution, are often loosely versioned, unverified, and non-reproducible.
Package removal is simple deletion of the download cache directory.

The project-specific container makes sharing C and C++ libraries as simple and
maintainable as in other languages providing a package repository. Each project
defines specific compiler and library versions, and different projects can use
different versions of the same compiler and libraries. The same containers used
for development can run the continuous integration builds and tests, with the
same process used to create a container for deployment. Projects can make use
of new compiler and library features or test support for a variety of systems
using an assortment of containers.

## GNU Guix

GNU Guix is a general purpose package manager installed as either a full Linux
operating system or atop a running foreign distribution. Guix operates on a
rolling release schedule, with package additions and updates submitted through
community contributions. Packages are built in a standard, isolated environment
in order to be reproducible, and the content-addressable package artifacts are
referenced by one or more user profiles and assembled using Linux's [overlay
filesystem](https://www.kernel.org/doc/html/latest/filesystems/overlayfs.html).
Guix packages can be built locally or downloaded as signed binary substitutes.

Guix can export a collection of packages in container format. The listing of
packages is specified in a manifest, and can define new packages or modify
existing packages with version updates or a revised configuration. The exported
container is reproducibly defined by a package manifest and channel definition,
which references the Guix repository and commit ID. Rather than updating and
testing individual dependencies, developers can update to a new Guix revision
and expect a coherent set of compatible upgrades. The Guix model has now scaled
to [21,000+ packages](https://packages.guix.gnu.org).
