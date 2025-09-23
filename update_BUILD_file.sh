#!/bin/bash

# *******************************************************************************
# Copyright (c) 2024 Contributors to the Eclipse Foundation
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

set -euo pipefail

BUILD_FILE="BUILD"
BACKUP_FILE="BUILD.backup"

echo "Updating BUILD file with crate_index aliases..."

# Create a backup of the current BUILD file
cp "$BUILD_FILE" "$BACKUP_FILE"
echo "Created backup: $BACKUP_FILE"

# Create a temporary file for the new BUILD content
tmp_file=$(mktemp)
processed_file=$(mktemp)

# Clean up temporary files on exit
trap 'rm -f "$tmp_file" "$processed_file"' EXIT

# Write the BUILD file header
cat > "$BUILD_FILE" << 'EOF'
# BUILD file to satisfy Bazel package requirements for extensions.bzl
# This file contains auto-generated aliases from @crate_index
# Generated aliases for crate_index entries
EOF

echo "# Generated on: $(date)" >> "$BUILD_FILE"
echo "" >> "$BUILD_FILE"

# Query all targets from @crate_index and store in temp file
echo "Querying @crate_index targets..."
bazel query "@crate_index//..." 2>/dev/null > "$tmp_file"

# Process each target and generate unique aliases
while read -r target; do
    # Extract the target name after the last ':'
    target_name=$(echo "$target" | sed 's/.*://')
    
    # Skip if target_name is empty or contains unwanted patterns
    if [[ -z "$target_name" || "$target_name" == *"BUILD"* || "$target_name" == *"defs"* || "$target_name" == "srcs" ]]; then
        continue
    fi
    
    # Remove version suffix (everything from the first dash followed by a digit)
    # Example: futures-0.3.31 -> futures, clap-4.5.4 -> clap
    crate_name=$(echo "$target_name" | sed 's/-[0-9].*//')
    
    # Skip if the crate_name is empty after processing
    if [[ -z "$crate_name" ]]; then
        continue
    fi
    
    # Replace dashes with underscores for valid Bazel target names
    bazel_name=$(echo "$crate_name" | tr '-' '_')
    
    # Check if we already processed this crate name
    if grep -q "^$bazel_name$" "$processed_file" 2>/dev/null; then
        continue
    fi
    
    # Add to processed list
    echo "$bazel_name" >> "$processed_file"
    
    # Prefer non-versioned targets if they exist
    preferred_target="$target"
    if [[ "$target_name" == *"-"*[0-9]* ]]; then
        # This is a versioned target, check if non-versioned exists
        non_versioned="@crate_index//:$crate_name"
        if grep -q "^$non_versioned$" "$tmp_file"; then
            preferred_target="$non_versioned"
        fi
    fi
    
    # Append the alias to BUILD file
    cat >> "$BUILD_FILE" << EOF
alias(
    name = "$bazel_name",
    actual = "$preferred_target",
    visibility = ["//visibility:public"],
)

EOF
    
    echo "Added alias: $bazel_name -> $preferred_target"
done < "$tmp_file"

# Add footer
echo "# End of generated aliases" >> "$BUILD_FILE"

echo ""
echo "BUILD file updated successfully!"
echo "Backup saved as: $BACKUP_FILE"
echo "Generated $(grep -c '^alias(' "$BUILD_FILE") aliases"