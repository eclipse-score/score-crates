# crate_repo tests

This directory is a separate Bazel module that consumes `score_crates` and selects its own crate
repository through the `crate_repo` extension (default `fallback = True`). Run from this directory:

```bash
cd tests && bazel test //...
```

`@my_crates` is a stub repository that only provides `pastey`. The tests check that
`@score_crates//:pastey` resolves to `@my_crates` and that `@score_crates//:adler32`, which the stub
lacks, falls back to `@crate_index`.
