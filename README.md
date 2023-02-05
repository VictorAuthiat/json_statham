Not deployed yet.

# JsonStatham

A Ruby library for carefully refactoring json objects.
You can use this library when you want to change your serialization system.
For example if you want to migrate from [fast_jsonapi](https://github.com/Netflix/fast_jsonapi) to another library.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add json_statham

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install json_statham

## Usage

Configure the `schemas_path`.

```ruby
JsonStatham.configure do |config|
  config.schemas_path = "schemas"
end
```

Now you can extend `JsonStatham` to use `.stathamnize` method.

Example:

```ruby
module Foo
  extend JsonStatham

  def self.call(hash)
    result = stathamnize("foo") { hash }

    result.success?
  end
end
```

Running `Foo.call({ foo: :bar })` will create a new file **foo.json** in a **schemas** directory. This file contain the json schema and execution duration.

Example:

```json
{"schema":{"bar":"symbol"},"duration":2.9999937396496534e-06}
```

It returns a `JsonStatham::Result` object.
You can execute `success?` or `failure?` on JsonStatham::Result.
Running `Foo.call` a second time with a new hash schema and `store_schema = false` will not create a new file and result a failure.

## Configuration:

Available configuration attributes:

```ruby
JsonStatham.configure do |config|
  config.store_schema = true
  config.schemas_path = "schemas"
  config.logger       = true
end
```

*Required attributes:*

- `schemas_path` The path where the json files will be read and created

*Optional attributes:*

- `store_schema` Default to `false`. It allows to create or not a new file

- `logger` Default to `false`. It allows to create or not a new file

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/json_statham. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/json_statham/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JsonStatham project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/json_statham/blob/master/CODE_OF_CONDUCT.md).
