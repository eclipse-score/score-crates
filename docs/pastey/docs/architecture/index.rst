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

.. _pastey_architecture_design:

Component Architecture
======================

.. document:: Pastey Architecture
   :id: doc__mod_pastey_architecture
   :status: valid
   :safety: ASIL_B
   :security: NO
   :realizes: wp__component_arch
   :tags: architecture, component, rust, proc_macro

Overview
--------

``pastey`` is a Rust procedural macro crate that provides compile-time token
manipulation and identifier synthesis. It operates entirely at compile time
within the Rust compiler's macro expansion phase.

Static Architecture
-------------------
The pastey crate is single component architecture consisting of a single Rust crate that defines the
``paste!`` macro.

.. uml:: static_design.puml

Interfaces
----------
The pastey crate consists of a single proc-macro entry point that processes
token streams passed to the ``paste!`` macro invocation. All processing occurs
at compile time with no runtime footprint.

.. uml:: public_api.puml
