# ActiveStorage::PostgreSQL

ActiveStorage Service to store files PostgeSQL.



## Installation
Add this line to your application's Gemfile:

```ruby
gem 'active_storage-postgresql', git: "https://github.com/lsylvester/active_storage-postgresql"
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

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveStorage::PostgreSQL project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lsylvester/active_storage-postgresql/blob/master/CODE_OF_CONDUCT.md).
