# Copyright 2017 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# My custom made integration test framework for using Bazel
load(":bazel_hash_dict.bzl", "BAZEL_HASH_DICT")

BAZEL_VERSIONS = BAZEL_HASH_DICT.keys()

_BAZEL_BINARY_PACKAGE = "http://releases.bazel.build/{version}/release/bazel-{version}-without-jdk-installer-{platform}.sh"

def _get_platform_name(rctx):
  os_name = rctx.os.name.lower()
  # We default on linux-x86_64 because we only support 2 platforms
  return "darwin-x86_64" if os_name.startswith("mac os") else "linux-x86_64"

def _get_installer(rctx):
  platform = _get_platform_name(rctx)
  version = rctx.attr.version
  url = _BAZEL_BINARY_PACKAGE.format(version=version, platform=platform)
  args = {"url": url, "type": "zip", "output": "bin"}
  if version in BAZEL_HASH_DICT and platform in BAZEL_HASH_DICT[version]:
    args["sha256"] = BAZEL_HASH_DICT[version][platform]
  rctx.download_and_extract(**args)

def _bazel_repository_impl(rctx):
  _get_installer(rctx)
  rctx.file("WORKSPACE", "workspace(name='%s')" % rctx.attr.name)
  rctx.file("BUILD", """
genrule(
  name = "bazel_binary",
  outs = ["bazel"],
  srcs = ["bin/bazel-real"],
  cmd = "cp $< $@",
  output_to_bindir = True,
  visibility = ["//visibility:public"])""")

bazel_binary = repository_rule(
  implementation=_bazel_repository_impl,
  attrs = {"version": attr.string(default = "0.5.3")})

def bazel_binaries(versions = BAZEL_VERSIONS):
  for version in versions:
    bazel_binary(
      name = "build_bazel_bazel_" + version.replace(".", "_"),
      version = version)
