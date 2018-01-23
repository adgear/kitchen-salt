## patch

* Provide a CI script for validating `CHANGES.md`
* Provide a CI script to automate releases
* Refactor `.travis.yml` to allow for the new CI suites
* Refactor `CHANGES.md` to be readable by the new CI scripts
* Makes an automated correction pass with Rubocop

## v0.2.0

* Adds support for PowerShell 2.0
* Fixes a bug that would prevent `salt_install: none` from working on Windows
* Adds ability to have drop-in files added to the minion configuration, see
  [`docs/provisioner_options.md`](./docs/provisioner_options.md#salt_minion_config_dropin_files)
* Adds ability to add options to the minion configuration directly from `.kitchen.yml`,
  see [`docs/provisioner_options.md`](./docs/provisioner_options.md#salt_minion_extra_config)

## v0.1.0

* Two years worth of changes!

## v0.0.19
* Added ability to copy additional dependency formulas into the VM
  See [`docs/provisioner_options.md`](./docs/provisioner_options.md#dependencies)

## v0.0.18
* Added ability to filter paths from the set of files copied to the guest
  See [`docs/provisioner_options.md`](./docs/provisioner_options.md#salt_copy_filter)
* Added is_file_root flag - treat this project as a complete file_root.
  See [`docs/provisioner_options.md`](./docs/provisioner_options.md#is_file_root)
* Pillar data specified using the pillars-from-files option are no longer
  passed through YAML.load/.to_yaml
  This was causing subtle data transformations with unexpected results when
  the reuslting yaml was consumed by salt
* Added "Data failed to compile" and "No matching sls found for" to
  strings we watch salt-call output for signs of failure
