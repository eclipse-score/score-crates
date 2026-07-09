..
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

S-CORE Crates Documentation
============================

This repository is the `Eclipse S-CORE <https://eclipse.dev/score/>`_ centralized collection of Rust external crates. It provides a single source for all external crates used in the S-CORE Rust codebase,
which can be consumed by other modules by adding this module as a dependency.
The repository also contains safety-related artifacts for external crates, enabling other modules to meet the safety requirements of the S-CORE platform.

.. contents:: Table of Contents
   :depth: 2
   :local:

.. toctree::
   :titlesonly:
   :hidden:

   rust_crate_safety_guideline
   safety_mgt/module_safety_plan
   verification_report/module_verification_report
   crates_index

Documentation Structure
-----------------------

Safety and Verification
~~~~~~~~~~~~~~~~~~~~~~~

The :doc:`Rust Crate Safety Guideline <rust_crate_safety_guideline>` provides safety guidelines for safety qualifying Rust crates.

The :doc:`Module Safety Plan <safety_mgt/module_safety_plan>` covers safety management planning for the module.

The :doc:`Module Verification Report <verification_report/module_verification_report>` provides verification results and analysis guide.

Crates
~~~~~~

pastey
^^^^^^

The :doc:`Component Classification <pastey/docs/component_classification>` provides the classification result of the pastey component.

The :doc:`Architecture <pastey/docs/architecture/index>` covers the architectural design and structure of the pastey crate.
