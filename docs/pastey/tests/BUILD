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

load("@rules_rust//rust:defs.bzl", "rust_test", "rust_doc_test", "rust_library")

rust_test(
    name = "pastey_test",
    srcs = ["pastey_test.rs"],
    proc_macro_deps = [
        "@crate_index//:pastey",
    ],
    visibility = ["//visibility:public"],
)

# This is require for running doc test
rust_library(
    name = "pastey_test_lib",
    srcs = ["pastey_test.rs"],
    proc_macro_deps = [
        "@crate_index//:pastey",
    ],
    visibility = ["//visibility:public"],
)

rust_doc_test(
    name = "pastey_doc_test",
    crate = ":pastey_test_lib",
    visibility = ["//visibility:public"],
)
