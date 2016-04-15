#!/bin/bash
# relies on $LINUX_REPO and $LINUX_SHA1 being set
# GITHUB_TOKEN is generated at GitHub account with only "repo:status" access

TEST_FAILURE_FILE="$LINUX_REPO/test-failure.txt"
GITHUB_STATUS_URL="https://api.github.com/repos/facebook/react-native/statuses/$LINUX_SHA1?access_token=$GITHUB_TOKEN"

TEST_STATUS="success"
TEST_DESCRIPTION="OS X tests succeeded"

if [[ -f $TEST_FAILURE_FILE ]]
  then
    TEST_STATUS="failure"
    TEST_DESCRIPTION="OS X tests failed"
fi

curl \
  --header "Content-Type: application/json" \
  --data "{ \"state\": \"$TEST_STATUS\", \
           \"target_url\": \"$CIRCLE_BUILD_URL\", \
           \"description\": \"$TEST_DESCRIPTION\", \
           \"context\": \"ci/circleci-os-x\" }" \
  --request POST "$GITHUB_STATUS_URL"