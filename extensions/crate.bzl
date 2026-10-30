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
"""Module extension to select the crate repository behind the aliases of the root BUILD file.

By default the aliases forward to @crate_index of this module. The root module can
select its own crate repository instead:

    crate_repo = use_extension("@score_crates//extensions:crate.bzl", "crate_repo")
    crate_repo.use(repo = "@my_crates")

Crates missing in the selected repository are taken from `fallback_repo` (default: @crate_index).
Set `fallback = False` to fail the build instead. Fallback crates pull their own dependencies from
`fallback_repo`, which can lead to duplicate crates if the same dependencies also exist in the selected repo.
"""

load("//:crates.bzl", "CRATE_TARGETS")
load("//rules:crate.bzl", "crate_alias_repo")

# Resolved relative to this module, so it is our own crate_index.
_CRATE_INDEX = Label("@crate_index//:crate_index")

def _crate_repo_impl(module_ctx):
    repo = _CRATE_INDEX.repo_name
    fallback_repo = _CRATE_INDEX.repo_name
    fallback = True
    index_build = None

    selected = None
    for module in module_ctx.modules:
        if not module.is_root:
            continue
        for use in module.tags.use:
            if selected != None:
                fail("crate_repo.use() may only be called once in the root module.")
            selected = use
    if selected != None:
        repo = selected.repo.repo_name
        fallback_repo = selected.fallback_repo.repo_name
        fallback = selected.fallback
        index_build = Label("@@{}//:BUILD.bazel".format(repo))

    crate_alias_repo(
        name = "score_crates_index",
        repo = repo,
        fallback_repo = fallback_repo,
        fallback = fallback,
        index_build = index_build,
        targets = CRATE_TARGETS,
    )

    return module_ctx.extension_metadata(reproducible = True)

_use = tag_class(
    attrs = {
        "repo": attr.label(
            mandatory = True,
            doc = "Crate repository (e.g. \"@my_crates\") that provides the crates listed in crates.bzl.",
        ),
        "fallback": attr.bool(
            default = True,
            doc = "Take crates missing in `repo` from `fallback_repo` instead of failing.",
        ),
        "fallback_repo": attr.label(
            default = _CRATE_INDEX,
            doc = "Repository used for crates missing in `repo`. Only used if `fallback` is set.",
        ),
    },
    doc = "Replaces @crate_index. Only honored in the root module.",
)

crate_repo = module_extension(
    implementation = _crate_repo_impl,
    tag_classes = {"use": _use},
    doc = "Selects the crate repository used by the aliases in the root BUILD file.",
)
