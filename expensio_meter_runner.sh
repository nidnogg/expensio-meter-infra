#!/bin/bash
# This script expects you to
# 1. be on a sibling folder to expensio-meter
# 2. TO-DO add filepath for expensio-meter as input to JS
# 3. be properly authenticated with git
# 4. bun has to be initialized before!

# Define variables
ROOT_DIR=$(pwd)
EXPENSIO_METER_DIR="$HOME/localdev/expensio-meter"
EXPENSIO_METER_INFRA_DIR="$HOME/localdev/expensio-meter-infra"


run_checker_js() {
    bun $EXPENSIO_METER_INFRA_DIR/check_write_json.js
    return_value=$? 
    return $return_value
}

commit_delta() {
  echo "Committing expensio-meter currency data..."
  cd $EXPENSIO_METER_DIR || exit 1
  git stage data
  current_date=$(date +"%Y-%m-%d")
  git commit -m "New currency data from $current_date"
  git push origin HEAD
  cd $ROOT_DIR
}

# Main script

run_checker_js
if [ $? -eq 1 ]; then # check_write runs 1 for no updates needed.
    echo "expensio-meter last_fetch_at is under 24 hours old. Ignoring updates"
    exit 0  # Exit the script with a non-zero status code
else
    echo "expensio-meter last_fetch_at is over 24 hours old. New data has been fetched."
    commit_delta || { echo "Failed to commit date delta for expensio-meter." ; exit 1; }
fi
