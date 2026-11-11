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
"""Expose a cross-arch sysroot's complete --sysroot argument as a Make variable."""

load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

def _get_sysroot_root(srcs, marker):
    """Return the directory ending in the `marker` path component.

    e.g. `external/repo/aarch64/usr/include/x.h` with marker "aarch64" ->
    `external/repo/aarch64`. `srcs` may also contain host-tree files that live
    outside the marker (e.g. `external/repo/x86_64/usr/bin/...`); those are
    skipped. Every file that *does* sit under the marker must agree on the root.
    """
    needle = "/" + marker + "/"
    root = None

    for f in srcs:
        path = "/" + f.path
        idx = path.find(needle)
        
        if idx == -1:
            continue

        candidate = (path[:idx] + "/" + marker)[1:]
 
        if root == None:
            root = candidate
            continue
        elif root != candidate:
            fail("sysroot srcs resolve to multiple roots: {} vs {}".format(root, candidate))

    if root == None:
        fail("no sysroot file under marker component {}; check sysroot_strip_prefix".format(marker))

    return root


def _sysroot_dir_impl(ctx):
    srcs = ctx.files.srcs
    marker = ctx.attr.strip_prefix[BuildSettingInfo].value

    root = _get_sysroot_root(srcs, marker) if srcs else ""

    # Complete, optional bindgen --sysroot argument. Empty when no sysroot is
    # configured (sysroot_source left at its :empty default) so native AArch64
    # Linux builds keep using their normal system headers instead of being
    # redirected to --sysroot=<execroot>/.
    #
    # Consumed via $(SYSROOT_ARG) in build_script_env. The $$ survives Bazel
    # make-variable expansion as a single $, so rules_rust can substitute
    # ${pwd} with the absolute exec root at build-script runtime.
    sysroot_arg = "--sysroot=$${{pwd}}/{}".format(root) if root else ""

    return [
        DefaultInfo(files = depset(srcs)),
        platform_common.TemplateVariableInfo({
            "SYSROOT_ARG": sysroot_arg,
        }),
    ]


sysroot_dir = rule(
    implementation = _sysroot_dir_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "Sysroot files (e.g. @score_autosd_10_cross_toolchain//:all_files).",
        ),
        "strip_prefix": attr.label(
            default = "//sysroots:sysroot_strip_prefix",
            providers = [BuildSettingInfo],
            doc = "string_flag naming the path component that begins the sysroot root.",
        ),
    },
    doc = "Exposes the complete, optional bindgen --sysroot argument as the SYSROOT_ARG Make variable (empty when no sysroot is configured).",
)
