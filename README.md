# GraphQL DSL

[![main](https://github.com/maxd/graphql-dsl/actions/workflows/main.yml/badge.svg)](https://github.com/maxd/graphql-dsl/actions/workflows/main.yml)

`graphql-dsl` lets you easy create GraphQL queries by code:

```ruby
puts query(:aliveCharacters, species: [:String!, 'Human']) {
  characters(filter: { status: 'Alive', species: :$species }) {
    results {
      name
      image
    }
  }
}.to_gql
```

```graphql
query aliveCharacters($species: String! = "Human")
{
  characters(filter: {status: "Alive", species: $species})
  {
    results
    {
      name
      image
    }
  }
}
```

## Contents

* [Why?](#why)
* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)
 
## Why?

I wanted to create GraphQL queries by code with some Ruby DSL instead of writing gigantic blocks of text. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-dsl'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install graphql-dsl

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, 
which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to 
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maxd/graphql-dsl. This project is intended 
to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the 
[code of conduct](https://github.com/maxd/graphql-dsl/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GraphQlDsl project's codebases, issue trackers, chat rooms and mailing lists is expected to 
follow the [code of conduct](https://github.com/maxd/graphql-dsl/blob/master/CODE_OF_CONDUCT.md).
