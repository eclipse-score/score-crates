# *******************************************************************************
# Copyright (c) 2025 Contributors to the Eclipse Foundation
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

"""A macro to generate a C++ bridge library from a `#[cxx::bridge]` Rust module.

It runs the `cxxbridge` code generator (provided by the vendored `@rust_cxx`
repository) over a Rust source file to produce the matching C++ header and
source, and exposes them as a `cc_library`.
"""

load("@bazel_skylib//rules:run_binary.bzl", "run_binary")
load("@rules_cc//cc:defs.bzl", "cc_library")

def rust_cxx_bridge(name, src, deps = []):
    """Defines a cxx bridge library.

    Args:
        name (string): The name of the new target.
        src (string): The Rust source file to generate a bridge for.
        deps (list, optional): Dependencies for the underlying cc_library.
    """
    native.alias(
        name = "%s/header" % name,
        actual = src + ".h",
    )

    native.alias(
        name = "%s/source" % name,
        actual = src + ".cc",
    )

    run_binary(
        name = "%s/generated" % name,
        srcs = [src],
        outs = [
            src + ".h",
            src + ".cc",
        ],
        args = [
            "$(location %s)" % src,
            "-o",
            "$(location %s.h)" % src,
            "-o",
            "$(location %s.cc)" % src,
        ],
        tool = Label("@rust_cxx//:cxxbridge"),
    )

    cc_library(
        name = "%s/include" % name,
        hdrs = [src + ".h"],
    )

    cc_library(
        name = name,
        srcs = [src + ".cc"],
        linkstatic = True,
        deps = deps + [":%s/include" % name],
    )
