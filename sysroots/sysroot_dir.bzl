# *******************************************************************************
# Copyright (c) 2026 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0
# *******************************************************************************
"""Materialize a set of sysroot files into a single directory (TreeArtifact).

`--sysroot` needs a directory path, but `$(execpath)` on a filegroup yields
individual files. This rule copies the files into one declared directory so its
`$(execpath)` is the sysroot root, usable as `--sysroot=$(execpath :target)`.
"""

def _sysroot_dir_impl(ctx):
    out = ctx.actions.declare_directory(ctx.attr.name)
    args = ctx.actions.args()
    args.add(out.path)
    args.add(ctx.attr.strip_prefix)
    args.add_all(ctx.files.srcs)
    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        outputs = [out],
        arguments = [args],
        # $1 = output dir, $2 = path component after which to keep the relative
        # path (e.g. "sysroot"), rest = source files.
        command = """
set -eu
out="$1"; shift
marker="$1"; shift
for f in "$@"; do
  rel="${f##*/${marker}/}"
  dst="$out/$rel"
  mkdir -p "$(dirname "$dst")"
  cp -P "$f" "$dst"
done
""",
        mnemonic = "MakeSysroot",
        progress_message = "Materializing sysroot %{label}",
    )
    return [DefaultInfo(files = depset([out]))]

sysroot_dir = rule(
    implementation = _sysroot_dir_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "Sysroot files (e.g. @autosd_10_gcc_cross_repo//:sysroot_files).",
        ),
        "strip_prefix": attr.string(
            default = "sysroot",
            doc = "Path component after which the relative sysroot path begins.",
        ),
    },
    doc = "Copies sysroot files into one directory TreeArtifact for use as --sysroot.",
)
