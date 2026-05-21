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

load("@bazel_skylib//rules:common_settings.bzl", "bool_flag")

def sphinx_build_settings(name = "sphinx_build_flags", visibility = None):
    bool_flag(
        name = "use_native_sphinx_build",
        build_setting_default = False,
        visibility = visibility,
    )

    native.config_setting(
        name = "use_wrapper",
        flag_values = {
            ":use_native_sphinx_build": "False",
        },
        visibility = visibility,
    )

    native.config_setting(
        name = "use_native",
        flag_values = {
            ":use_native_sphinx_build": "True",
        },
        visibility = visibility,
    )
