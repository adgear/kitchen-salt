#!/usr/bin/env bash

if [ "$SUITE" == "changelog" ]; then
  exit 0
elif [ "$SUITE" == "rubocop" ]; then
  exit 0
elif [ "$SUITE" == "shellcheck" ]; then
  exit 0
else
  bundle exec kitchen list "$SUITE"
  bundle exec rake "integration:destroy[$SUITE]"
fi
