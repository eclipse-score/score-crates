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
load(":sysroot_dir.bzl", "sysroot_dir")

# only relevant for linux cross arch. builds
config_setting(
    name = "is_aarch64_linux",
    constraint_values = [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
    visibility = ["//visibility:public"],
)

# empty filegroup for non cross arch. builds
filegroup(
    name = "empty",
    srcs = [],
)

# Optional Label flag that allows different platforms/toolchains to point to their cross arch. sysroot in Bazel
# Defaults to empty if not set
# Example: build:autosd-xaarch64 --@@score_crates+//sysroots:sysroot_source=@autosd_10_gcc_cross_repo//:sysroot_files
label_flag(
    name = "sysroot_source",
    build_setting_default = ":empty",
    visibility = ["//visibility:public"],
)

# Rule that setups the sysroot based on the previous criteria/rules
sysroot_dir(
    name = "aarch64_linux",
    srcs = select({
        ":is_aarch64_linux": [":sysroot_source"],
        "//conditions:default": [],
    }),
    visibility = ["//visibility:public"],
)
