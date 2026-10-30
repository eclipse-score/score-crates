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
"""Test repository that mimics the layout of a crate_universe hub repository."""

def _fake_crate_repo_impl(repository_ctx):
    content = "".join(['filegroup(name = "{}", visibility = ["//visibility:public"])\n'.format(c) for c in repository_ctx.attr.crates])
    repository_ctx.file("BUILD.bazel", content)

fake_crate_repo = repository_rule(
    implementation = _fake_crate_repo_impl,
    attrs = {"crates": attr.string_list(mandatory = True)},
)
