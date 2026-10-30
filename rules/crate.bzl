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
"""Repository rule that generates aliases to the selected crate repository."""

def _crate_alias_repo_impl(repository_ctx):
    attr = repository_ctx.attr
    available = None
    if attr.index_build:
        content = repository_ctx.read(attr.index_build)
        available = {t: True for t in attr.targets if "name = \"{}\"".format(t) in content}

    lines = []
    missing = []
    for target in attr.targets:
        repo = attr.repo
        if available != None and target not in available:
            missing.append(target)
            repo = attr.fallback_repo
        lines.append("alias(name = \"{t}\", actual = \"@@{r}//:{t}\", visibility = [\"//visibility:public\"])".format(
            t = target,
            r = repo,
        ))

    if missing:
        if not attr.fallback:
            fail("Crate repository @@{} does not provide: {}. Add them or remove fallback = False.".format(
                attr.repo,
                ", ".join(missing),
            ))

        # buildifier: disable=print
        print("score_crates: using @@{} as fallback for: {}".format(attr.fallback_repo, ", ".join(missing)))

    repository_ctx.file("BUILD.bazel", "\n".join(lines) + "\n")

crate_alias_repo = repository_rule(
    implementation = _crate_alias_repo_impl,
    attrs = {
        "repo": attr.string(mandatory = True, doc = "Canonical name of the crate repository."),
        "fallback_repo": attr.string(mandatory = True, doc = "Canonical name of the repository used for missing crates."),
        "fallback": attr.bool(default = True, doc = "Use fallback_repo for crates missing in repo instead of failing."),
        "index_build": attr.label(allow_single_file = True, doc = "BUILD file of the selected repo, used to check which crates exist. Unset for the default repo."),
        "targets": attr.string_list(mandatory = True),
    },
)
