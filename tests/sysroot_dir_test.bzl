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
load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")


def _root_test_impl(ctx):
    env = analysistest.begin(ctx)
    target = analysistest.target_under_test(env)

    # Pure-analysis rule: it must not register any actions.
    asserts.equals(
        env,
        0,
        len(analysistest.target_actions(env)),
        "sysroot_dir should register no actions",
    )

    # SYSROOT_DIR make variable holds the computed root.
    template_vars = target[platform_common.TemplateVariableInfo].variables
    asserts.true(
        env,
        "SYSROOT_DIR" in template_vars,
        "SYSROOT_DIR make variable must be defined",
    )
    asserts.equals(env, ctx.attr.expected_root, template_vars["SYSROOT_DIR"])

    # DefaultInfo carries *all* srcs (target + host tree) so the target works
    # as build_script_data; nothing is dropped during root computation.
    basenames = [f.basename for f in target[DefaultInfo].files.to_list()]
    asserts.equals(
        env,
        ctx.attr.expected_file_count,
        len(basenames),
        "DefaultInfo should expose every src file",
    )
    for name in ctx.attr.expected_basenames:
        asserts.true(
            env,
            name in basenames,
            "expected %r in DefaultInfo files, got %r" % (name, basenames),
        )

    return analysistest.end(env)

sysroot_root_test = analysistest.make(
    _root_test_impl,
    attrs = {
        "expected_root": attr.string(mandatory = True),
        "expected_basenames": attr.string_list(),
        "expected_file_count": attr.int(mandatory = True),
    },
)


def _empty_test_impl(ctx):
    env = analysistest.begin(ctx)
    target = analysistest.target_under_test(env)
    template_vars = target[platform_common.TemplateVariableInfo].variables
    
    asserts.equals(env, "", template_vars["SYSROOT_DIR"])
    asserts.equals(env, 0, len(target[DefaultInfo].files.to_list()))

    return analysistest.end(env)

sysroot_empty_test = analysistest.make(_empty_test_impl)


def _conflict_test_impl(ctx):
    env = analysistest.begin(ctx)
    
    asserts.expect_failure(env, "resolve to multiple roots")
    
    return analysistest.end(env)


sysroot_conflict_test = analysistest.make(
    _conflict_test_impl,
    expect_failure = True,
)
