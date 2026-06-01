Pastey Architectural Design
============================

Overview
--------

``pastey`` is a Rust procedural macro crate that provides compile-time token
manipulation and identifier synthesis. It operates entirely at compile time
within the Rust compiler's macro expansion phase.

.. uml:: static_design.puml

Public API
----------

.. uml:: public_api.puml

Component Structure
-------------------

The pastey crate consists of a single proc-macro entry point that processes
token streams passed to the ``paste!`` macro invocation. All processing occurs
at compile time with no runtime footprint.