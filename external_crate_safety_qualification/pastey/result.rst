Pastey - Safety Qualification Results
=====================================

Crate Information
-----------------

**Crate Name:** pastey

**Type:** Procedural Macro (proc-macro)

**Purpose:** A small-sized procedural macro providing identifier pasting and case modification capabilities with environment variable support.

**Description:** Pastey is a Rust procedural macro crate designed to provide convenient syntax for identifier construction. It supports various features including identifier pasting, case modifiers (uppercase, lowercase, snake_case, etc.), ``env!`` macro support, raw mode, and replace modifiers.

**Repository:** https://github.com/as1100k/pastey

**Documentation:** https://docs.rs/pastey/0.2.1/pastey/

**Crate Version:** 0.2.1

**Key Characteristics:**

* Single public interface (one main macro function)
* 917 lines of code (excluding tests and comments)
* No unsafe code
* Comprehensive test suite covering unit and integration tests
* CI/CD with multi-version Rust testing (nightly, beta, stable, 1.54)
* LLVM-based code coverage reporting

**Qualification Date:** ....

**Assessed By:** ....

Safety Qualification Assessment
--------------------------------

Step 1: Determine (P): the uncertainty of the Processes applied
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 5 50 10 35

   * - Id
     - Indicator for applying process
     - Result
     - Rationale for result

   * - 1
     - Are rules, state-of-the art processes applied for the design, implementation and verification?
     - PE
     - The project follows standard Rust open-source practices.
       
       CI verifications include:
       
       * test suite (4 Rust versions: nightly, beta, stable, 1.54)
       * MSRV check
       * Documentation generation
       * Clippy linting strict warnings enforced (-Dwarnings)
       * Miri UB detection
       * dependency staleness checks
       
       This is a small-size proc-macro so relevant details are in the crate documentation, which includes usage, feature overview, brief detail of macro, APIs and use-cases examples.

   * - 2
     - Are requirements available?
     - PE
     - As this is small size procedural macro crate so functional requirements are partially captured in crate documentation as expected macro behaviors (identifier pasting, case modifiers, ``env!`` support, raw mode, replace modifier) with each feature explanation.
       
       CHANGELOG entries, and linked GitHub issues for all kind of new development.

   * - 3
     - Are design specifications available?
     - PE
     - It is small crate structure with one public interface so it does not required UML/Class diagram but all the relevant details are part of crate document.

   * - 4
     - Are specifications for functionalities and properties available (architecture)?
     - PE
     - It is small procedural macro so crate documentation contains the partially specifications for functionalities and their properties through feature descriptions, usage examples, and modifier tables.

   * - 5
     - Are configuration specification and data available, if applicable?
     - HE
     - Not applicable.
       
       The crate does not use any runtime configuration, environment-based settings, or configuration files. So no configuration specification is applicable or needed.

   * - 6
     - Are verification measures including tests and reports available?
     - HE
     - Comprehensive test suite exists, test files covering unit tests, integration tests (tests).
       
       An LLVM-based code coverage report is generated and available at index.html.

Step 2: Determine (C): the uncertainty of finding systematic faults based on the Complexity
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 5 40 30 10 10 20

   * - Id
     - Indicator for high Complexity
     - Complexity measure Tool
     - Result
     - Number
     - Comment

   * - 1
     - High amount of Lines of Code
     - Lines of Code (without comments) (generated code is excluded, e.g. ProtoCmpl)
     - NH
     - 917
     - Excluding tests

   * - 2
     - Unsafe code used / total unsafe code
     - LoUC+N: lines of unsafe code with safety note. LoUC: lines of unsafe code, no safety note
     - NH
     - 0
     - No unsafe code

   * - 3
     - Test exists / Coverage (Function, Line)
     - Existing Tests Coverage
     - NH
     - Comprehensive test suite with LLVM-based code coverage report available
     - With this PR https://github.com/AS1100K/pastey/pull/28, code coverage is -
         * 100% function coverage
         * 96.5% line coverage (C0) (missing lines are for error handling paths in the code, which are difficult to cover with tests)
         * 93.2% branch coverage(C1) (missing branches are for error handling paths in the code, which are difficult to cover with tests)

   * - 4
     - High amount of public function interfaces
     - Number of public function interfaces
     - NH
     - 1
     - pastey macro has only 1 function

   * - 5
     - High amount of function parameters
     - Number of parameters
     - NH
     - 1
     - TokenStream is a only parameter for proc macro

Step 3: Determine (CLAS_OUT): the classification outcome
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 20 20 20 20

   * - 
     - C=1
     - C=2
     - C=3

   * - P=1
     - Q
     - Q
     - QR

   * - P=2
     - QR
     - QR
     - QR

   * - P=3
     - QR
     - QR
     - NQ

**Result: Classification Outcome**

Based on the assessment:

* P (Processes) = 1
* C (Complexity) = 2
* **CLAS_OUT (Classification Outcome) = Q**

**Classification Results:**

* **Q:** Follow the processes for qualification of software components in a safety context.
* **QR:** Follow the process for pre-existing software architectural elements.
* **NQ:** Do not use this element in safety context.


Assessment References document:  https://eclipse-score.github.io/score/main/modules/feo/feo/docs/component_classification.html
