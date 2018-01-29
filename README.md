# kitchen-salt
[![Gem Version](https://badge.fury.io/rb/kitchen-salt.svg)](https://badge.fury.io/rb/kitchen-salt)
[![Gem Downloads](https://ruby-gem-downloads-badge.herokuapp.com/kitchen-salt?type=total&color=brightgreen)](https://rubygems.org/gems/kitchen-salt)
[![Build Status](https://travis-ci.org/saltstack/kitchen-salt.png)](https://travis-ci.org/saltstack/kitchen-salt)

A Test Kitchen Provisioner for Salt

The provider works by generating a salt-minion config, creating pillars based
on attributes in `.kitchen.yml` and calling `salt-call`.

This provisioner is tested with kitchen-docker against CentOS, Ubuntu, and
Debian.

## Documentation and usage

Consult [kitchen.saltstack.com](https://kitchen.saltstack.com)


## Contributing

Consult [`CONTRIBUTING.md`](./CONTRIBUTING.md)


## History

Consult [`CHANGE.md`](./CHANGE.md).


## License

Consult [`LICENSE`](./LICENSE).
