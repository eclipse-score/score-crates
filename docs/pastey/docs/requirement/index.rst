Requirements
============

.. document:: Pastey Crate Requirements Traceability Matrix
   :id: doc__pastey_aou
   :status: valid
   :safety: NO
   :security: NO
   :realizes: wp__requirements_comp

.. aou_req:: Identifier Pasting
   :id: pastey_req__pasting__1
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   Identifiers listed inside ``[< ... >]`` within a ``paste!`` invocation must
   be concatenated into a single identifier. Whitespace between tokens inside
   ``[< ... >]`` must be ignored. Example: ``[<Q R S T>]`` produces ``QRST``.

   Test case traceability:
    - `pastey-test-suite/tests/test_item.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_item.rs>` - ``test_basic::test``

.. aou_req:: Case Modifier — lower
   :id: pastey_req__case__1
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   The ``:lower`` modifier must convert the pasted value to lowercase using
   ``str::to_lowercase``.

   Test case traceability:
    - `pastey-test-suite/tests/test_item.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_item.rs>` - ``test_to_lower::test_to_lower``

.. aou_req:: Case Modifier — upper
   :id: pastey_req__case__2
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   The ``:upper`` modifier must convert the pasted value to uppercase using
   ``str::to_uppercase``.

   Test case traceability:
    - `pastey-test-suite/tests/test_item.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_item.rs>` - ``test_to_upper::test_to_upper``

.. aou_req:: Case Modifier — snake
   :id: pastey_req__case__3
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   The ``:snake`` modifier must convert the pasted value to snake_case.

   Test case traceability:
    - `pastey-test-suite/tests/test_item.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_item.rs>` - ``test_to_snake::test_to_snake``

.. aou_req:: Case Modifier — camel / upper_camel
   :id: pastey_req__case__4
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   The ``:camel`` and ``:upper_camel`` modifiers must convert the pasted value
   to UpperCamelCase. Behaviour must match the ``paste`` crate baseline.

   Test case traceability:
    - `pastey-test-suite/tests/test_item.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_item.rs>` - ``test_to_camel::test_to_camel``

.. aou_req:: Case Modifier — lower_camel
   :id: pastey_req__case__5
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   The ``:lower_camel`` modifier must convert the pasted value to lowerCamelCase.

   Test case traceability:
    - `pastey-test-suite/tests/test_item.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_item.rs>` - ``test_to_lower_camel::test_to_lower_camel``

.. aou_req:: Case Modifier — camel_edge
   :id: pastey_req__case__6
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   The ``:camel_edge`` modifier must convert the pasted value to UpperCamelCase
   while preserving edge-case boundaries (e.g. consecutive uppercase letters).

   Test case traceability:
    - `pastey-test-suite/tests/test_item.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_item.rs>` - ``test_to_camel_edge::test_to_camel_edge``

.. aou_req:: Environment Variable Expansion
   :id: pastey_req__env__1
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   ``env!("VAR_NAME")`` inside ``[< ... >]`` must resolve to the value of the
   named environment variable at compile time. Hyphens in the resolved value
   must be replaced with underscores. An undefined variable must produce a
   compile error.

   Test case traceability:
    - `pastey-test-suite/tests/test_expr.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_expr.rs>` - ``test_env_literal``, ``test_env_present``

.. aou_req:: Replace Modifier
   :id: pastey_req__replace__1
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   The ``:replace(from, to)`` modifier must perform string replacement on the
   preceding pasted value using ``str::replace`` semantics. The ``from`` and
   ``to`` arguments each accept a string literal, char literal, identifier, or
   single-token macro interpolation. More than one token in either argument must
   produce a compile error. A missing preceding value must produce a compile error.
   Incorrect syntax (wrong separator, missing parentheses, extra tokens) must
   produce a compile error.

   Test case traceability:
    - `pastey-test-suite/tests/test_item.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_item.rs>` - ``test_replace_string_literal::test_replace``, ``test_replace::test_replace``

.. aou_req:: Raw Identifier Generation
   :id: pastey_req__raw__1
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   Prefixing a token inside ``[< ... >]`` with ``#`` must enable raw mode,
   producing a raw identifier (``r#ident``). The ``#`` token must only be
   permitted as the first token inside ``[< ... >]``, any other position must
   produce a compile error.

   Test case traceability:
    - `pastey-test-suite/tests/test_item.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_item.rs>` - ``test_raw_mode::test_fn``, ``test_item_raw_mode_paste::test_raw_ident_via_item``

.. aou_req:: Documentation String Concatenation
   :id: pastey_req__doc__1
   :reqtype: Functional
   :security: NO
   :safety: NO
   :status: valid

   Arguments to a ``#[doc = ...]`` attribute inside a ``paste!`` invocation must
   be implicitly concatenated to form a single documentation string.

   Test case traceability:
    - `pastey-test-suite/tests/test_doc.rs <https://github.com/AS1100K/pastey/blob/main/pastey-test-suite/tests/test_doc.rs>` - ``test_paste_doc``, ``test_escaping``, ``test_literals``, ``test_case``, ``test_stringify``
