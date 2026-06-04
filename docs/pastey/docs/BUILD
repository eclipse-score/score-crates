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

load(
    "@score_tooling//bazel/rules/rules_score:rules_score.bzl",
    "assumptions_of_use",
    "dependable_element",
    "dependability_analysis",
)

assumptions_of_use(
    name = "aou",
    srcs = ["//docs/pastey/docs/safety_analysis:aou_trlc"],
    visibility = ["//visibility:public"],
)

dependability_analysis(
    name = "pastey_dependability_analysis",
    arch_design = "//docs/pastey/docs/design:pastey_design",
    fmea = ["//docs/pastey/docs/safety_analysis:pastey_fmea"],
)

dependable_element(
    name = "pastey",
    integrity_level = "B",
    assumptions_of_use = [":aou"],
    requirements = [
        "//docs/pastey/docs/requirement:feature_requirements",
    ],
    architectural_design = ["//docs/pastey/docs/design:pastey_design"],
    components = ["//docs/pastey/docs/component:pastey_component"],
    dependability_analysis = [":pastey_dependability_analysis"],
    tests = ["//docs/pastey/tests:pastey_test"],
)
