# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.24)
project(c++ LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)

# implemented only for Makefile and ninja generators
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# run clang-tidy as part of the compilation process
set(CMAKE_CXX_CLANG_TIDY clang-tidy)

# warnings can be safely and sanely turned into errors since the exact compiler
# version is specified by the GNU Guix channel and manifest used to create the
# container used for development and testing
add_compile_options(-Wall -Wextra -Werror)

enable_testing()

add_subdirectory(source)

# add custom target to run clang-format on all C++ files;
# this can be called from the command-line as `cmake --build . --target format`,
# or called explicitly using the generator as `ninja format` or `make format`
file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS source/*.[ch]pp)
add_custom_target(format COMMAND clang-format --dry-run -Werror ${SOURCE_FILES})
