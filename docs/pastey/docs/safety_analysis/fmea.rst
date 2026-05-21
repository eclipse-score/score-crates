Pastey FMEA – Failure Mode and Effects Analysis
================================================

.. list-table:: Failure Modes
   :header-rows: 1
   :widths: 10 30 20 20 20

   * - ID
     - Failure Mode
     - Guide Word
     - Failure Effect
     - Control Measure
   * - FM_PASTEY_001
     - The paste! macro fails to synthesize an identifier when the token stream is empty or whitespace-only.
     - LossOfFunction
     - Compilation fails with a macro expansion error.
     - CM_PASTEY_001: Emit compile error on empty interpolation block.
   * - FM_PASTEY_002
     - The paste! macro produces an incorrect identifier when an unsupported modifier is silently ignored.
     - Wrong
     - A wrong identifier is emitted causing silent logic errors.
     - CM_PASTEY_002: Emit compile error on unknown modifier.
   * - FM_PASTEY_003
     - The paste! macro expands tokens in a syntactically invalid position.
     - UnintendedFunction
     - Build failure due to invalid token placement in generated code.
     - AoU: Invoker shall only use paste! in syntactically valid positions.
