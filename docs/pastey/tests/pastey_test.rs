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

use pastey::paste;


// REQ_COMP_PASTEY_001 – identifier concatenation via paste!
paste! {
    struct [<Foo Bar>];
}

#[test]
fn test_identifier_concatenation() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_001
    let _ = FooBar;
}


// REQ_COMP_PASTEY_002 – :lower modifier
paste! {
    #[allow(non_upper_case_globals)]
    const [<HELLO_WORLD:lower>]: &str = "hello_world";
}

#[test]
fn test_lower_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_002
    assert_eq!(hello_world, "hello_world");
}


// REQ_COMP_PASTEY_003 – :upper modifier
paste! {
    #[allow(non_snake_case)]
    fn [<get_ value:upper>]() -> u32 { 42 }
}

#[test]
fn test_upper_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_003
    assert_eq!(get_VALUE(), 42);
}


// REQ_COMP_PASTEY_004 – :snake modifier
paste! {
    fn [<MyFunction:snake>]() -> &'static str { "snake_case" }
}

#[test]
fn test_snake_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_004
    assert_eq!(my_function(), "snake_case");
}


// REQ_COMP_PASTEY_005 / REQ_COMP_PASTEY_006 – :camel / :upper_camel modifier
paste! {
    #[allow(non_snake_case)]
    fn [<my_function:camel>]() -> &'static str { "UpperCamelCase" }
}

#[test]
fn test_camel_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_005
    assert_eq!(MyFunction(), "UpperCamelCase");
}


// REQ_COMP_PASTEY_006 – :lower_camel modifier
paste! {
    #[allow(non_snake_case)]
    fn [<MyFunction:lower_camel>]() -> &'static str { "lowerCamelCase" }
}

#[test]
fn test_lower_camel_modifier() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_006
    assert_eq!(myFunction(), "lowerCamelCase");
}


// REQ_COMP_PASTEY_009 – raw identifier prefix (#)
paste! {
    fn [<# type>]() -> &'static str { "raw identifier" }
}

#[test]
fn test_raw_identifier_prefix() {
    // lobster-trace: PasteyComReq.REQ_COMP_PASTEY_009
    assert_eq!(r#type(), "raw identifier");
}