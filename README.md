# GraphQL DSL

[![main](https://github.com/maxd/graphql-dsl/actions/workflows/main.yml/badge.svg)](https://github.com/maxd/graphql-dsl/actions/workflows/main.yml)

`graphql-dsl` lets you easy create GraphQL queries by code:

* without writing cumbersome heredoc
* allow to union queries dynamically without concatenation of string

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

* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)
 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-dsl', '~> 0.1.0'
```

And then execute `bundle install`.

## Usage

There are three ways how to use GraphQL DSL. 

1. Call methods of `GraphQL::DSL` module directly

    ```ruby
    rockets_query = GraphQL::DSL.query {
      rockets {
        name
      }
    }.to_gql
    
    puts rockets_query
    ```
    
1. Extend class or module with `GraphQL:DSL`

    ```ruby
    module SpaceXQueries
      extend GraphQL::DSL
      
      ROCKETS = query {
        rockets {
          name
        }
      }.to_gql
    end
    
    puts SpaceXQueries::ROCKETS
    ```
    
1. Include `GraphQL:DSL` to class

    ```ruby
    class SpaceXQueries
      include GraphQL::DSL
      
      # use memorization or lazy initialization 
      # to avoid generation of query on each method call 
      def rockets
        query {
          rockets {
            name
          }
        }.to_gql
      end
    end
    
    queries = SpaceXQueries.new
    puts queries.rockets
    ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To release a new version:

* update the version number in `lib/graphql/dsl/version.rb` file
* run `bundle exec rake readme:update` to update `README.md` file 
* run `bundle exec rake release` to create a git tag for the version, push git commits and the created tag, 
  and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maxd/graphql-dsl. This project is intended 
to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the 
[code of conduct](https://github.com/maxd/graphql-dsl/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GraphQL DSL project's codebases, issue trackers, chat rooms and mailing lists is expected to 
follow the [code of conduct](https://github.com/maxd/graphql-dsl/blob/master/CODE_OF_CONDUCT.md).
