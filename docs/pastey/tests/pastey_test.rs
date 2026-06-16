/********************************************************************************
 * Copyright (c) 2026 Contributors to the Eclipse Foundation
 *
 * See the NOTICE file(s) distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Apache License Version 2.0 which is available at
 * https://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0
 ********************************************************************************/

//! Integration tests demonstrating pastey compile-time token manipulation.
// This is because test related functions and structures are not used directly in the codebase,
// but are essential for validating the functionality of the pastey crate.
// Allowing dead code prevents compiler warnings about unused items while still ensuring that all test cases are present and can be executed.
#![allow(dead_code)]

use pastey::paste;

paste! {
    struct [<Foo Bar>];
}

#[test]
fn test_identifier_concatenation() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_001
    let _ = FooBar;
}

paste! {
    #[allow(non_upper_case_globals)]
    const [<HELLO_WORLD:lower>]: &str = "hello_world";
}

#[test]
fn test_lower_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_002
    assert_eq!(hello_world, "hello_world");
}

paste! {
    #[allow(non_snake_case)]
    fn [<get_ value:upper>]() -> u32 { 42 }
}

#[test]
fn test_upper_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_003
    assert_eq!(get_VALUE(), 42);
}

paste! {
    fn [<MyFunction:snake>]() -> &'static str { "snake_case" }
}

#[test]
fn test_snake_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_004
    assert_eq!(my_function(), "snake_case");
}

paste! {
    #[allow(non_snake_case)]
    fn [<my_function:camel>]() -> &'static str { "UpperCamelCase" }
}

#[test]
fn test_camel_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_005
    assert_eq!(MyFunction(), "UpperCamelCase");
}

paste! {
    #[allow(non_snake_case)]
    fn [<MyFunction:lower_camel>]() -> &'static str { "lowerCamelCase" }
}

#[test]
fn test_lower_camel_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_006
    assert_eq!(myFunction(), "lowerCamelCase");
}

paste! {
    #[allow(non_snake_case)]
    fn [<my_http_server:camel_edge>]() -> &'static str { "MyHttpServer" }
}

#[test]
fn test_camel_edge_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_007
    assert_eq!(MyHttpServer(), "MyHttpServer");
}

paste! {
    fn [<replace_test:replace(test, demo)>]() -> &'static str { "replace_demo" }
}

#[test]
fn test_replace_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_008
    assert_eq!(replace_demo(), "replace_demo");
}

paste! {
    fn [<# type>]() -> &'static str { "raw identifier" }
}

#[test]
fn test_raw_identifier_prefix() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_009
    assert_eq!(r#type(), "raw identifier");
}

paste! {
    /// [<Documentation for >] [<the struct>]
    struct [<DocumentedStruct>] {
        field: u32,
    }
}

#[test]
fn test_doc_attribute_concatenation() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_010
    let s = DocumentedStruct { field: 42 };
    assert_eq!(s.field, 42);
}

paste! {
    #[allow(non_snake_case)]
    fn [<get_PASTEY_VERSION>]() -> &'static str { env!("CARGO_PKG_VERSION") }
}

#[test]
fn test_environment_variable_lookup() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_011
    let version = get_PASTEY_VERSION();
    assert!(!version.is_empty());
}

// Documentation tests for error cases

/// Verify that empty interpolation blocks cause compilation errors
///
/// # lobster-trace: PasteyComReq.REQ_COMP_PASTEY_012
///
/// ```compile_fail
/// use pastey::paste;
/// 
/// paste! {
///     struct [<>];
/// }
/// ```
fn test_empty_token_stream_doc() {}

/// Verify that whitespace-only interpolation blocks cause compilation errors
///
/// # lobster-trace: PasteyComReq.REQ_COMP_PASTEY_013
///
/// ```compile_fail
/// use pastey::paste;
/// 
/// paste! {
///     struct [<   >];
/// }
/// ```
fn test_whitespace_only_stream_doc() {}

/// Verify that invalid case modifiers cause compilation errors
///
/// # lobster-trace: PasteyComReq.REQ_COMP_PASTEY_014
///
/// ```compile_fail
/// use pastey::paste;
/// 
/// paste! {
///     const [<INVALID:invalid_modifier>]: u32 = 42;
/// }
/// ```
fn test_invalid_modifier_doc() {}

/// Verify that malformed replace modifier syntax causes compilation errors
///
/// # lobster-trace: PasteyComReq.REQ_COMP_PASTEY_008
///
/// ```compile_fail
/// use pastey::paste;
/// 
/// paste! {
///     // Missing closing parenthesis
///     fn [<test:replace(foo, bar>]() {}
/// }
/// ```
fn test_malformed_replace_syntax_doc() {}

/// Verify that # in non-first position causes compilation errors
///
/// # lobster-trace: PasteyComReq.REQ_COMP_PASTEY_009
///
/// ```compile_fail
/// use pastey::paste;
/// 
/// paste! {
///     // # should only be at first position
///     fn [<my # type>]() {}
/// }
/// ```
fn test_hash_non_first_position_doc() {}

/// Verify that missing environment variables cause compilation errors
///
/// # lobster-trace: PasteyComReq.REQ_COMP_PASTEY_011
///
/// ```compile_fail
/// use pastey::paste;
/// 
/// paste! {
///     // NON_EXISTENT_VAR doesn't exist in build environment
///     const VERSION: &str = env!("NON_EXISTENT_BUILD_VAR_THAT_DOES_NOT_EXIST");
/// }
/// ```
fn test_missing_env_var_doc() {}

/// Verify that multiple tokens in replace modifier arguments cause compilation errors
///
/// # lobster-trace: PasteyComReq.REQ_COMP_PASTEY_015
///
/// ```compile_fail
/// use pastey::paste;
/// 
/// paste! {
///     // Multiple tokens in 'from' argument
///     fn [<test:replace(foo bar, baz)>]() {}
/// }
/// ```
fn test_replace_multiple_tokens_doc() {}
