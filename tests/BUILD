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
load("@bazel_skylib//rules:common_settings.bzl", "string_flag")
load("//sysroots:sysroot_dir.bzl", "sysroot_dir")
load(
    ":sysroot_dir_test.bzl",
    "sysroot_conflict_test",
    "sysroot_empty_test",
    "sysroot_root_test",
)

# Fixture shaped like a real cross-toolchain package: a target tree under
# aarch64/ and a host tree under x86_64/. `all_files`-style globs pick up both;
# only the target tree sits under the marker.
#   testdata/pkg/sysroot/aarch64/usr/include/foo.h  (target)
#   testdata/pkg/sysroot/aarch64/usr/lib/libfoo.a   (target)
#   testdata/pkg/sysroot/x86_64/usr/bin/ar          (host, skipped for root)
filegroup(
    name = "pkg_fixture",
    srcs = glob(["testdata/pkg/**"]),
)

# ---------------------------------------------------------------------------
# Marker "aarch64": root ends at the aarch64 component; the x86_64 host file is
# outside the marker and skipped during root computation (but still exposed).
# ---------------------------------------------------------------------------

string_flag(
    name = "marker_aarch64",
    build_setting_default = "aarch64",
)

sysroot_dir(
    name = "sysroot_aarch64_marker",
    srcs = [":pkg_fixture"],
    strip_prefix = ":marker_aarch64",
)

sysroot_root_test(
    name = "root_aarch64_marker_test",
    target_under_test = ":sysroot_aarch64_marker",
    expected_root = "tests/testdata/pkg/sysroot/aarch64",
    expected_basenames = ["foo.h", "libfoo.a", "ar"],
    expected_file_count = 3,
)

# ---------------------------------------------------------------------------
# Marker "sysroot": root ends at the sysroot component; every file sits under
# it, so all agree on the same root.
# ---------------------------------------------------------------------------

string_flag(
    name = "marker_sysroot",
    build_setting_default = "sysroot",
)

sysroot_dir(
    name = "sysroot_sysroot_marker",
    srcs = [":pkg_fixture"],
    strip_prefix = ":marker_sysroot",
)

sysroot_root_test(
    name = "root_sysroot_marker_test",
    target_under_test = ":sysroot_sysroot_marker",
    expected_root = "tests/testdata/pkg/sysroot",
    expected_basenames = ["foo.h", "libfoo.a", "ar"],
    expected_file_count = 3,
)

# ---------------------------------------------------------------------------
# Empty srcs (off the cross target, where the BUILD select yields []).
# ---------------------------------------------------------------------------

sysroot_dir(
    name = "sysroot_empty",
    srcs = [],
    strip_prefix = ":marker_aarch64",
)

sysroot_empty_test(
    name = "empty_srcs_test",
    target_under_test = ":sysroot_empty",
)

# ---------------------------------------------------------------------------
# Conflicting roots: two subtrees both under the marker -> analysis failure.
#   testdata/conflict/alpha/aarch64/...  -> .../alpha/aarch64
#   testdata/conflict/beta/aarch64/...   -> .../beta/aarch64
# ---------------------------------------------------------------------------

filegroup(
    name = "conflict_fixture",
    srcs = glob(["testdata/conflict/**"]),
)

sysroot_dir(
    name = "sysroot_conflict",
    srcs = [":conflict_fixture"],
    strip_prefix = ":marker_aarch64",
    tags = ["manual"],
)

sysroot_conflict_test(
    name = "conflict_roots_test",
    target_under_test = ":sysroot_conflict",
)

test_suite(
    name = "sysroot_dir_tests",
    tests = [
        ":conflict_roots_test",
        ":empty_srcs_test",
        ":root_aarch64_marker_test",
        ":root_sysroot_marker_test",
    ],
)
