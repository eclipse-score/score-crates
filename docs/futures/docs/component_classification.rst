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

Futures Crate Component Classification
======================================

.. document:: Futures Crate Component Classification
   :id: doc__futures_crate_comp_class
   :version: 1
   :status: draft
   :safety: ASIL_B
   :security: NO
   :realizes: wp__sw_component_class
   :tags: pre-existing, software-component, classification, Rust, async


| Classification of Futures Crate as a software component in the context of S-CORE.
|
| Repository: https://github.com/rust-lang/futures-rs
| Documentation: https://docs.rs/futures/0.3.34/futures/
| Crate Version: 0.3.34 (``futures`` and ``futures-core``, as resolved in ``Cargo.lock`` of this repository)
| Additional documentation considered:
| https://crates.io/crates/futures


Component used from the futures crate
-------------------------------------

Only the following items are used in production code of the Rust COM API. Everything else (``executor::block_on``, ``channel::oneshot``, ``FutureExt``, ``StreamExt``) is used in mock, example and test code only and is out of scope. The classified component is therefore ``futures-core``. The COM API imports the used items through the public paths ``futures::stream::Stream`` and ``futures::task::AtomicWaker`` (``consumer.rs`` of ``com-api-runtime-lola``); ``futures`` and ``futures-util`` only re-export them from ``futures-core``.

.. list-table:: Used items
    :header-rows: 1

    * - Item
      - Defined in
      - Used for
    * - ``Stream``
      - ``futures-core`` (``src/stream.rs``)
      - Return type of the public ``Subscription::to_stream()``
    * - ``AtomicWaker``
      - ``futures-core`` (``src/task/__internal/atomic_waker.rs``), re-exported as the public and documented ``futures::task::AtomicWaker`` (through ``futures-util``)
      - Wake-up of pending receive and discovery futures
    * - ``Context``, ``Poll``
      - ``core::task``, re-exported by ``futures``
      - No ``futures`` logic; provided by the Rust ``core`` library


Step 1: Determine (P): the uncertainty of the Processes applied
---------------------------------------------------------------

| Apply the process measures to determine (P).
| The result of a process measure shall have as outcome [HE, PE, NE]
| - HE: High Evidence
| - PE: Partly Evidence but Manageable
| - NE: No Evidence

The evidence below is taken from the upstream repository at tag ``0.3.34``. The usage of ``futures`` in the Rust COM API is summarized in the futures dependency review of the eclipse-score/communication repository. The ratings are proposed and are final only after review by the S-CORE Safety team.

.. list-table:: Determine (P)
    :header-rows: 1

    * - Id
      - Indicator for applying process
      - Result
      - Rationale for result

    * - 1
      - Are rules, state-of-the art processes applied for the design, implementation and verification?
      - PE
      - The project follows standard Rust open-source practices (upstream ``.github/workflows/ci.yml`` at tag ``0.3.34``).

        CI verifications include:

        * test suite (``cargo test --workspace --all-features``) on Linux, macOS, Windows and several cross-targets
        * Code Coverage generation with LLVM-based tools is not part of upstream CI (no coverage threshold is required for pull request approval); a report can be generated locally with ``cargo +nightly llvm-cov --workspace --all-features --branch``
        * build checks on stable, beta and nightly
        * MSRV check (1.36 for ``futures-core``)
        * ``no-std`` builds, feature powerset check and minimal-versions build
        * Documentation generation
        * Miri UB detection
        * address, memory and thread sanitizer runs
        * formatting check (``cargo fmt --check``)
        * dependency staleness checks (Dependabot)
        * CHANGELOG entries for each release in ``CHANGELOG.md``
        * Maintaining GitHub issues

        Not available: active Clippy job (commented out on the ``0.3`` branch) and ``cargo-audit`` / ``cargo-deny``.

        All CI jobs passed on the ``0.3.34`` tag commit (https://github.com/rust-lang/futures-rs/actions/runs/31490059232).

        * crate documentation: https://docs.rs/futures/0.3.34/futures/
        * documentation of the used component: https://docs.rs/futures-core/0.3.34/futures_core/
        * source of the used component: https://github.com/rust-lang/futures-rs/tree/0.3.34/futures-core/src

    * - 2
      - Are requirements available?
      - PE
      - The functional requirements of the used items are partially captured in the crate documentation (rustdoc) as expected behaviors, with usage guidance for each. No requirements exist in S-CORE form.

        * ``Stream`` (``futures-core`` ``src/stream.rs``): ``poll_next`` returns ``Poll::Pending`` when the next value is not ready and the implementation ensures the current task is notified when it may be ready; ``Poll::Ready(Some(val))`` yields a value; ``Poll::Ready(None)`` means the stream has terminated and ``poll_next`` should not be called again. Polling after termination may panic or block, but must never cause undefined behavior. ``size_hint`` gives bounds on the remaining length; it must not be trusted to omit bounds checks in unsafe code, and the default is ``(0, None)``.
        * ``AtomicWaker`` (``futures-core`` ``src/task/__internal/atomic_waker.rs``): consumers call ``register`` before checking the result and producers call ``wake`` after producing it; ``wake`` before ``register`` is a no-op; one ``AtomicWaker`` may be reused for any number of calls. Memory ordering: ``register`` acquires all memory released by earlier ``wake`` calls; for concurrent ``register`` calls (to be avoided) ordering is guaranteed only for the winning call. An example (``Flag``) shows the required check after ``register`` to avoid lost notifications.

        (crate documentation - https://docs.rs/futures-core/0.3.34/futures_core/stream/trait.Stream.html and https://docs.rs/futures/0.3.34/futures/task/struct.AtomicWaker.html)

        Missing: requirements in S-CORE form (TRLC) for the behavior used by the COM API.

    * - 3
      - Are specifications for functionalities and properties available (architecture)?
      - PE
      - The crate documentation partially specifies the functionality and properties of the used items, through the trait and type descriptions, return-state descriptions and a usage example (checked in ``futures-core`` 0.3.34):

        * ``Stream``: the trait is described as the asynchronous version of ``Iterator``, modeled after ``Future``; the ``poll_next`` return states, the behavior after termination and the ``size_hint`` properties are specified (see Id 2).
        * ``AtomicWaker``: the purpose, the ``register``/``wake`` calling pattern and the memory-ordering guarantees are specified (see Id 2). Comments in the source describe the implementation, which uses a single ``AtomicUsize`` with ``REGISTERING`` and ``WAKING`` bits, the single-producer behavior and the outcome of concurrent ``register`` calls.
        * The ``futures-core`` crate has a README (usage and minimum Rust version 1.36).

        The specification is partial: there is no separate specification document.

        Missing: specification in S-CORE form.

    * - 4
      - Are design specifications available?
      - PE
      - No UML or class diagram, no architecture or design document in the upstream repository (no ``docs`` or design directory in the 0.3.34 tree). The design of the used component is documented only in source comments, mainly the description of the ``AtomicWaker`` state handling (see Id 3). The used component is small (``futures-core``, 306 lines, see Step 2), but its unsafe code needs a design description.

        Missing: static design for the used parts (``Stream``, ``AtomicWaker``); to be created in score-crates.

    * - 5
      - Are configuration specification and data available, if applicable?
      - HE
      - Not applicable.

        The used component (``futures-core``) does not use any runtime configuration, environment-based settings or configuration files. So no configuration specification is applicable or needed. Only compile-time Cargo features (``std``, ``alloc``, optional ``portable-atomic``) select the compiled code.

    * - 6
      - Are verification measures including tests and reports available?
      - PE
      - Test suite exists in the upstream repository, with test files covering unit tests and integration tests (62 test files with 235 ``#[test]`` attributes in ``futures/tests``, including ``task_atomic_waker.rs`` and 13 ``stream*`` test files; further tests in ``futures-channel`` and ``futures-executor``). The ``futures-core`` crate has no tests of its own, and the published archives contain no test files.
        (test suite - https://github.com/rust-lang/futures-rs/tree/0.3.34/futures/tests)
        (test suite result is available from the CI run on the ``0.3.34`` tag commit, all 24 jobs passed - https://github.com/rust-lang/futures-rs/actions/runs/31490059232, or by running tests locally with ``cargo test --workspace --all-features`` command)

        An LLVM-based code coverage report is not generated in upstream CI (the pull-request checks contain no coverage job, e.g. - https://github.com/rust-lang/futures-rs/pull/3069/checks). It can be generated locally on tag ``0.3.34`` with ``cargo +nightly llvm-cov --workspace --all-features --branch``, with 66.7% function coverage, 85.1% line coverage and 64.3% branch coverage of the used ``AtomicWaker`` (details in Step 2, Id 3).

        Missing: coverage report in CI; 100% coverage of the used items.


| (P=1) shall be selected when none of the determined process measures indicate PE or NE.
| (P=2) shall be selected when at least one of the determined process measures indicate PE or NE, but the gaps evaluated are acceptable, means
|       the risk of systematic faults due to these gaps is sufficiently low or manageable by mitigating the gaps.
| (P=3) in all other cases.
|

Futures crate is proposed as **P = 2** (to be confirmed by the Safety team).


Step 2: Determine (C): the uncertainty of finding systematic faults based on the Complexity
-------------------------------------------------------------------------------------------

| Apply the complexity measures to determine (C).
| The result of a complexity measure shall have as outcome [NH, HM, NM]
| - NH: Not High
| - HM: High but Manageable
| - NM: high and Not Manageable

The numbers below are measured on ``futures-core`` 0.3.34. Lines of code and unsafe code are counted for the whole crate; public interfaces and parameters are counted for the used items only. Lines of code are non-blank lines in ``src/**/*.rs`` not starting with ``//``. The ratings are proposed and are final only after review by the S-CORE Safety team.

.. list-table:: Determine (C)
    :header-rows: 1

    * - Id
      - Indicator for high Complexity
      - Complexity measure Tool
      - Result
      - Number

    * - 1
      - High amount of Lines of Code
      - Lines of Code (without comments) (generated code is excluded, e.g. ProtoCmpl)
      - NH
      - 306 (whole crate)

    * - 2
      - Unsafe code used / total unsafe code
      - Count:
            * LoUC+N: lines of unsafe code with safety note
            * LoUC  : lines of unsafe code, no safety note
      - HM
      - 5 source lines containing ``unsafe`` in the whole crate, 4 of them in the used items:

        * ``atomic_waker.rs`` (used): two ``unsafe`` blocks, ``unsafe impl Send`` and ``unsafe impl Sync``
        * ``stream.rs`` (not used): one ``unsafe`` block in ``impl Stream for AssertUnwindSafe`` (``std`` feature)

        * LoUC+N: 0 (no ``// SAFETY:`` notes in ``futures-core``)
        * LoUC: 4 in the used items. The two ``unsafe`` blocks in ``register`` and ``take`` are justified only by short comments that the lock is held, and by the module-level description of the locking protocol; ``unsafe impl Send/Sync`` have no comment.

    * - 3
      - | Test exists / Coverage (Function, Line)
        | (maybe better: testability, but how to measure?)
      - Existing Tests Coverage
      - HM
      - Test suite exists upstream with LLVM-based code coverage measured locally on tag ``0.3.34`` (``cargo +nightly llvm-cov --workspace --all-features --branch``). Code coverage of the used ``AtomicWaker`` (``atomic_waker.rs``) is -

        * 66.7% function coverage (4/6) (missing functions are ``Default::default`` and ``Debug::fmt``, which are not used by the COM API)
        * 85.1% line coverage (C0) (40/47) (missing lines are ``Default``, ``Debug`` and the ``debug_assert!`` in the losing path of concurrent ``register`` calls, which the crate documentation says should be avoided)
        * 64.3% branch coverage (C1) (9/14) (missing branches are the ``debug_assert!`` conditions of the same concurrent ``register`` path and the failing side of a ``debug_assert!`` in ``take``, which is only reached on an invalid internal state)

        Whole ``futures-core`` crate: 40.0% function, 58.1% line coverage; the uncovered code is mainly in ``FusedStream``, ``TryStream``, ``FusedFuture``, ``TryFuture`` and ``AssertUnwindSafe`` implementations, which are not used.
        Coverage of the concurrent paths depends on thread timing and may vary between runs.
        (coverage report can be generated by running tests locally with ``cargo +nightly llvm-cov --workspace --all-features --branch`` command; not available in upstream CI)

    * - 4
      - High amount of public function interfaces
      - Number of public function interfaces
      - NH
      - 6 for the used items in ``futures-core`` 0.3.34: ``Stream::poll_next``, ``Stream::size_hint`` (default method), ``AtomicWaker::new``, ``AtomicWaker::register``, ``AtomicWaker::wake``, ``AtomicWaker::take``. The COM API calls ``new``, ``register`` and ``wake``, and implements ``poll_next``. (Other public items of ``futures-core``, such as ``FusedStream`` and ``TryStream``, are not used and not counted.)

    * - 5
      - High amount of function parameters
      - Number of parameters
      - NH
      - At most 2 (``poll_next(self: Pin<&mut Self>, cx: &mut Context<'_>)``; ``register(&self, waker: &Waker)``); ``new`` has none, ``size_hint``, ``wake`` and ``take`` only take ``&self``.

Note: ``futures`` has custom atomic code and manual ``Send``/``Sync`` implementations in ``AtomicWaker``, which requires careful safety analysis during qualification.

| (C=1) shall be selected when none of the determined complexity measures indicate HM or NM.
| (C=2) shall be selected when at least one of the determined complexity measures indicate HM or NM, but the gaps evaluated are acceptable, means
|       the risk of systematic faults due to these gaps is sufficiently low in the context of S-CORE or manageable by mitigating the gaps.
| (C=3) in all other cases.
|

Futures crate is proposed as **C = 2** (to be confirmed by the Safety team).


Step 3: Determine (CLAS_OUT): the classification outcome
--------------------------------------------------------

| Select CLAS_OUT depending on the determined values of (C) and (P)

.. list-table::
   :header-rows: 1
   :widths: 20 20 20 20

   * -
     - P=1
     - P=2
     - P=3

   * - C=1
     - Q
     - Q
     - QR

   * - C=2
     - QR
     - QR
     - QR

   * - C=3
     - QR
     - QR
     - NQ


Futures crate is proposed as **CLAS_OUT = QR**, as it has **P = 2** and **C = 2** (to be confirmed by the Safety team).


Step 4: Document all results and rationale for choosing (P) and (C) and (CLAS_OUT)
----------------------------------------------------------------------------------

| Results (proposed, to be confirmed by the Safety team):
| - P = 2 (Partly Evidence but Manageable): indicators 1-4 and 6 show PE and indicator 5 is HE. The gaps are acceptable and manageable, because the used component (``futures-core``) is small and its upstream CI runs tests, Miri and sanitizers, which passed on 0.3.34. The missing CI coverage, requirements and design can be added with reasonable effort (as done for ``pastey``, see Additional notes).
| - C = 2 (High but Manageable): lines of code, public interfaces and parameters are NH. The unsafe code in ``AtomicWaker`` (custom atomics, manual ``Send``/``Sync``) is HM, and coverage is below 100% (``AtomicWaker``: 85.1% line, 64.3% branch coverage).
| - CLAS_OUT = QR, from P = 2 and C = 2 according to the classification criteria.
|
| This classification is a proposal and not a qualification or certification claim.


Step 5: Based on (CLAS_OUT) select the activities
-------------------------------------------------

Futures crate is proposed as **CLAS_OUT = QR** (to be confirmed by the Safety team).

| As soon as the change request containing this is in status "Accepted", the module safety plan for the component development is adapted based on the following: (select according to above result)
| - Q: Follow the processes for qualification of software components in a safety context.
| - QR: Follow the process for pre-existing software architectural elements
| - NQ: Do no use this element in safety context
|

Additional notes:

Traceability:
End-to-end traceability is not yet established for the futures crate: no requirements, design, failure modes, control measures or traced tests exist yet. They can be generated in a follow-up in the same way as for ``pastey``: next to this document in ``docs/futures/docs/``, add ``requirement/`` (assumed system, feature and component requirements in TRLC), ``architecture/`` (static design and public API in PlantUML), ``safety_analysis/`` (AoU and failure modes, for example missed wake-up and stalled stream), ``component/`` and ``tests/``, wired in a ``BUILD`` file as a ``dependable_element`` with integrity level B (``rules_score`` from ``score_tooling``). Traceability is then reported with the LOBSTER tool; unit test results are not currently displayed in the generated reports due to a known limitation in Rust test result parsing (https://github.com/bmw-software-engineering/lobster/issues/589).

Toolchain Assurance:
In this repository the crate is built with the Ferrocene toolchain, which is maintained as part of the score_toolchains_rust repository (``.bazelrc``, x86_64 Linux). The upstream tests run with the standard Rust toolchains (nightly, stable, beta and MSRV), not with Ferrocene; running the tests with the Ferrocene toolchain is open.

Use of Standard Library Components in futures-core:
The ``futures-core`` crate is ``#![no_std]``. The used items use only Rust core library components (``core::task`` for ``Context``, ``Poll`` and ``Waker``, ``core::pin``, ``core::cell::UnsafeCell`` and ``core::sync::atomic``). With the enabled ``alloc`` and ``std`` features, ``alloc`` is used for the ``BoxStream`` and ``BoxFuture`` type aliases and ``std`` only for the ``Stream`` and ``FusedFuture`` implementations for ``std::panic::AssertUnwindSafe``; these are not used by the COM API. Since they are sourced from the same Ferrocene toolchain, they use the same underlying components.

Code Coverage:
An LLVM-based code coverage report is not generated in upstream CI. Measured locally, coverage of the used ``AtomicWaker`` is 66.7% function, 85.1% line and 64.3% branch coverage; the missing parts are ``Default``, ``Debug`` and ``debug_assert!`` checks on concurrent or invalid states (see Step 2, Id 3). To reach 100% coverage, as done for ``pastey`` with tests (https://github.com/AS1100K/pastey/pull/28) and a CI coverage job (https://github.com/AS1100K/pastey/pull/30), tests for these paths and a coverage job can be proposed upstream to ``futures-rs``, or coverage can be run in score-crates if the ``0.3`` maintenance branch does not accept it.
