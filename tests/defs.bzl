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
"""Test helpers."""

load("@bazel_skylib//rules:build_test.bzl", "build_test")

def resolved_repo_test(name, target, contains = [], excludes = []):
    """Checks which repository `target` resolves to.

    Args:
        name: Name of the test.
        target: Aliased target whose first two alias hops are inspected.
        contains: Strings that must appear in the resolved labels.
        excludes: Strings that must not appear in the resolved labels.
    """
    native.genquery(
        name = name + "_labels",
        expression = "deps({}, 2)".format(target),
        scope = [target],
    )

    checks = ["grep -qF '{}' $(location :{}_labels)".format(s, name) for s in contains]
    checks += ["! grep -qF '{}' $(location :{}_labels)".format(s, name) for s in excludes]
    native.genrule(
        name = name + "_check",
        srcs = [":" + name + "_labels"],
        outs = [name + ".ok"],
        cmd = " && ".join(checks + ["touch $@"]),
    )

    build_test(name = name, targets = [":" + name + "_check"])
