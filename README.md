# SCORE Crates - Bazel Rust Dependencies Manager

This repository provides a centralized management system for Rust crate dependencies using Bazel's crate_universe.

## Overview

The SCORE Crates repository implements a streamlined approach for Rust crate dependencies that:

- **Defines crates directly** in `MODULE.bazel` using `crate.spec()`
- **Uses rules_rust crate_universe** for dependency resolution
- **Provides convenient aliases** via auto-generated BUILD file
- **Automatically syncs aliases** with `@crate_index` targets

## Problem Statement

### The Rust Crate Dependency Clash

When multiple Bazel modules depend on each other and both pull in Rust crates via rules_rust, Bazel pulls in the same crate multiple times. This leads to name clashes in the Rust compiler, even when using identical versions.

#### Without SCORE Crates (❌ Problem):
```
    Module A                    Module B
    ├── crate.spec(serde)       ├── crate.spec(serde)
    └── @crate_index_a//:serde  └── @crate_index_b//:serde
                    ↘                     ↙
                      Your Application
                    (💥 Name clash: two different serde crates!)
```

#### With SCORE Crates (✅ Solution):
```
              SCORE Crates Module
              ├── crate.spec(serde)
              └── @crate_index//:serde
                       ↙        ↘
            Module A              Module B
            (uses SCORE)          (uses SCORE)
                  ↘                ↙
                  Your Application
               (✅ Single serde crate!)
```

### Benefits of Centralized Crate Management

- **Eliminates duplicate crates**: Only one instance of each crate version across the entire workspace
- **Prevents name clashes**: Rust compiler sees consistent crate definitions
- **Simplifies dependency management**: Single source of truth for all crate versions
- **Reduces build times**: No duplicate compilation of the same crates
- **Ensures consistency**: All modules use identical crate versions and features

## Repository Structure

```
score-crates/
├── BUILD                   # Auto-generated aliases from @crate_index
├── MODULE.bazel            # Bazel module with crate specifications  
├── update_BUILD_file.sh    # Script to sync BUILD with @crate_index
└── README.md               # This file
```

## Key Components

### 1. MODULE.bazel
The **single source of truth** for crate definitions using `crate.spec()`:

```starlark
module(name = "score-crates")

bazel_dep(name = "rules_rust", version = "0.61.0")

crate = use_extension("@rules_rust//crate_universe:extensions.bzl", "crate")

crate.spec(
    package = "clap",
    version = "4.5.4",
    features = ["derive"],
)
crate.spec(
    package = "futures", 
    version = "0.3.31",
)
# Add more crate.spec() calls here...

crate.from_specs(name = "crate_index")
use_repo(crate, "crate_index")
```

### 2. BUILD File
Contains **auto-generated aliases** pointing to `@crate_index` targets:
```starlark
alias(
    name = "clap",
    actual = "@crate_index//:clap",
    visibility = ["//visibility:public"],
)
```

### 3. Auto-sync Script
The `update_BUILD_file.sh` script automatically generates aliases for all crates found in `@crate_index`.

## Usage

### Basic Usage in Your Bazel Workspace

1. **Add as a dependency** in your `MODULE.bazel`:
```starlark
bazel_dep(name = "score-crates", version = "1.0.0")
```

2. **Use crates in your BUILD files**:
```starlark
load("@rules_rust//rust:defs.bzl", "rust_binary")

rust_binary(
    name = "my_app",
    srcs = ["main.rs"],
    deps = [
        "@score-crates//:clap",      # Via local aliases
        "@score-crates//:futures",   # Via local aliases
    ],
)
```


## Adding New Crates

1. **Edit MODULE.bazel** - Add a new `crate.spec()` call:
```starlark
crate.spec(
    package = "tokio",
    version = "1.40.0",
    features = ["full"],
)
```

1. **Update aliases** - Run the sync script:
```bash
./update_BUILD_file.sh
```

1. **The crate will be available as**:
   - `@score-crates//:tokio` (via local alias)

