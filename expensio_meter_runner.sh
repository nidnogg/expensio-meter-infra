#!/bin/bash
# This script expects you to
# 1. be on a sibling folder to expensio-meter
# 2. TO-DO add filepath for expensio-meter as input to JS
# 2. be properly authenticated with git and gh

# Define variables
ROOT_DIR=$(pwd)
EXPENSIO_METER_DIR="$HOME/localdev/expensio-meter"
EXPENSIO_METER_INFRA_DIR="$HOME/localdev/expensio-meter-infra"


# generate_tarball() {
#     cargo build --release
#     cd target/release || exit 1
#     tar -czf zeitfetch.tar.gz zeitfetch
# }

# calculate_shasum() {
#     shasum -a 256 zeitfetch.tar.gz | awk '{print $1}'
# }

run_checker_js() {
    bun $EXPENSIO_METER_INFRA_DIR/check_write_json.js || { echo "Failed at check_write_json.js step for expensio-meter" ; exit 1; }
    return_value=$? 
    return $return_value
}

commit_delta() {
  echo "Committing expensio-meter currency data..."
  cd $EXPENSIO_METER_DIR || exit 1
  git stage $EXPENSIO_METER_DIR/data
  current_date=$(date +"%Y-%m-%d")
  git commit -m "New currency data from $current_date"
  git push origin HEAD
}

# Main script

run_checker_js
# check_write runs 1 for no updates needed.
if [ $? -eq 1 ]; then
    echo "expensio-meter last_fetch_at is under 24 hours old. Ignoring updates"
    exit 0  # Exit the script with a non-zero status code
else
    echo "expensio-meter last_fetch_at is over 24 hours old. New data has been fetched."
    commit_delta || { echo "Failed to commit date delta for expensio-meter." ; exit 1; }
fi
# version_number=$(get_version_number)
# generate_tarball
# shasum_output=$(calculate_shasum)

# echo "shasum hash:"
# echo
# echo "$shasum_output"

# gh release create "v$version_number" --generate-notes ./zeitfetch.tar.gz

# echo "Editing hash & version numbers in homebrew-zeitfetch repo..."
# update_homebrew_metadata "$version_number" "$shasum_output"
# echo "Successfully updated hash with shasum hash: $shasum_output"

# cd "$HOMEBREW_ZEITFETCH_DIR" || exit 1
# git stage .
# git commit -m "Update to version v$version_number"
# git push origin HEAD

# cd "$ROOT_DIR" || exit 1
# echo "Finished release cycle. SHA-256 hash for Notion archival: $shasum_output"



