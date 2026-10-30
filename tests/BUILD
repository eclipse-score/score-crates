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

load(":defs.bzl", "resolved_repo_test")

# Provided by the selected repository (@my_crates).
resolved_repo_test(
    name = "provided_crate_uses_selected_repo",
    target = "@score_crates//:pastey",
    contains = ["my_crates//:pastey"],
    excludes = ["crate_index//:pastey"],
)

# Not provided by @my_crates, so the default fallback takes it from @crate_index.
resolved_repo_test(
    name = "missing_crate_falls_back_to_crate_index",
    target = "@score_crates//:adler32",
    contains = ["crate_index//:adler32"],
    excludes = ["my_crates"],
)
