load("@rules_cc//cc:defs.bzl", "cc_library")
load("@rules_rust//rust:defs.bzl", "rust_binary", "rust_library", "rust_proc_macro")

rust_library(
    name = "cxx",
    srcs = glob(["src/**/*.rs"]),
    crate_features = [
        "alloc",
        "std",
        "c++17",
    ],
    edition = "2021",
    proc_macro_deps = [
        ":cxxbridge-macro",
    ],
    visibility = ["//visibility:public"],
    deps = [
        ":core-lib",
        "@crate_index//:foldhash",
    ],
)

alias(
    name = "codegen",
    actual = ":cxxbridge",
    visibility = ["//visibility:public"],
)

rust_binary(
    name = "cxxbridge",
    srcs = glob(["gen/cmd/src/**/*.rs"]),
    compile_data = glob(["gen/cmd/src/gen/**/*.h"]),
    edition = "2021",
    visibility = ["//visibility:public"],
    deps = [
        "@crate_index//:clap",
        "@crate_index//:codespan-reporting",
        "@crate_index//:indexmap",
        "@crate_index//:proc-macro2",
        "@crate_index//:quote",
        "@crate_index//:syn",
    ],
)

cc_library(
    name = "core",
    hdrs = ["include/cxx.h"],
    include_prefix = "rust",
    strip_include_prefix = "include",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "core-lib",
    srcs = ["src/cxx.cc"],
    hdrs = ["include/cxx.h"],
    linkstatic = True,
)

rust_proc_macro(
    name = "cxxbridge-macro",
    srcs = glob(["macro/src/**/*.rs"]),
    edition = "2021",
    proc_macro_deps = [
        "@crate_index//:rustversion",
    ],
    deps = [
        "@crate_index//:indexmap",
        "@crate_index//:proc-macro2",
        "@crate_index//:quote",
        "@crate_index//:syn",
    ],
)

rust_library(
    name = "cxx-build",
    srcs = glob(["gen/build/src/**/*.rs"]),
    compile_data = glob(["gen/build/src/gen/**/*.h"]),
    edition = "2021",
    deps = [
        "@crate_index//:cc",
        "@crate_index//:codespan-reporting",
        "@crate_index//:indexmap",
        "@crate_index//:proc-macro2",
        "@crate_index//:quote",
        "@crate_index//:scratch",
        "@crate_index//:syn",
    ],
)

rust_library(
    name = "cxx-gen",
    srcs = glob(["gen/lib/src/**/*.rs"]),
    compile_data = glob(["gen/lib/src/gen/**/*.h"]),
    edition = "2021",
    visibility = ["//visibility:public"],
    deps = [
        "@crate_index//:cc",
        "@crate_index//:codespan-reporting",
        "@crate_index//:indexmap",
        "@crate_index//:proc-macro2",
        "@crate_index//:quote",
        "@crate_index//:syn",
    ],
)
