# ActiveStorage::PostgreSQL

[![Gem Version](https://badge.fury.io/rb/active_storage-postgresql.svg)](https://badge.fury.io/rb/active_storage-postgresql)
[![Build Status](https://travis-ci.com/lsylvester/active_storage-postgresql.svg?branch=main)](https://travis-ci.com/lsylvester/active_storage-postgresql)

ActiveStorage Service to store files PostgeSQL.

Files are stored in PostgreSQL as Large Objects, which provide streaming style access.
More information about Large Objects can be found [here](https://www.postgresql.org/docs/current/static/largeobjects.html).

This allows use of ActiveStorage on hosting platforms with ephemeral file systems such as Heroku without relying on third party storage services.

There are [some limits](https://dba.stackexchange.com/questions/127270/what-are-the-limits-of-postgresqls-large-object-facility) to the storage of Large Objects in PostgerSQL, so this is only recommended for prototyping and very small sites.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'active_storage-postgresql'
```

And then execute:
```bash
$ bundle
```

In config/storage.yml set PostgreSQL as the service

```yaml
local:
  service: PostgreSQL
```

Copy over the migrations:

```
rails active_storage:install
rails active_storage:postgresql:install
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lsylvester/active_storage-postgresql. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Acknowledgments

Special thanks to [diogob](https://github.com/diogob) whos work on  [carrierwave-postgresql](https://github.com/diogob/carrierwave-postgresql) inspired this.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveStorage::PostgreSQL project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lsylvester/active_storage-postgresql/blob/main/CODE_OF_CONDUCT.md).
