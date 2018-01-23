#!/usr/bin/env bash

if [ "$SUITE" == "changelog" ]; then
  # Run the changelog test
  bundle exec rake "changelog:verify"
elif [ "$SUITE" == "rubocop" ]; then
  bundle exec rubocop -c ./.rubocop.yml \
                      --list-target-files \
                      --fail-level R \
                      --display-cop-names \
                      --extra-details \
                      --display-style-guide \
                      --no-color \
                      .
elif [ "$SUITE" == "shellcheck" ]; then
  # This should really be a rake task
  # And it sould be nice and check if shellcheck is installed
  find . -name '*.sh*' -exec shellcheck {} \; 
else
  # Run test-kitchen with docker driver:
  bundle exec rake "integration:verify[$SUITE]"
fi
