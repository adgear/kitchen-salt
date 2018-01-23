# kitchen-salt
[![Gem Version](https://badge.fury.io/rb/kitchen-salt.svg)](https://badge.fury.io/rb/kitchen-salt)
[![Gem Downloads](https://ruby-gem-downloads-badge.herokuapp.com/kitchen-salt?type=total&color=brightgreen)](https://rubygems.org/gems/kitchen-salt)
[![Build Status](https://travis-ci.org/saltstack/kitchen-salt.png)](https://travis-ci.org/saltstack/kitchen-salt)

A Test Kitchen Provisioner for Salt

The provider works by generating a salt-minion config, creating pillars based on attributes in .kitchen.yml and calling salt-call.

This provisioner is tested with kitchen-docker against CentOS, Ubuntu, and Debian.

## Documentation

https://kitchen.saltstack.com

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

Consult [`CHANGE.md`](./CHANGE.md).

Tests enforce you describe your changes. The text you write will be used for the
release and is subject to review.

Be mindful that every PR merged will constitute a release and must be sane
and deployable.

## License

Consult [`LICENSE`](./LICENSE).
