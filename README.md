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
* [Getting Started](#getting-started)
* [Development](#development)
 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-dsl', '~> 0.1.0'
```

And then execute `bundle install`.

## Getting Started

Choose appropriate way for your for use GraphQL DSL:

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
      
      # Create constant with GraphQL query
   
      ROCKETS = query {
        rockets {
          name
        }
      }.to_gql
    end
    
    puts SpaceXQueries::ROCKETS
    ```

    ```ruby
    module SpaceXQueries
      extend GraphQL::DSL
      extend self # required to call of `SpaceXQueries.rockets`   
   
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
    
    puts SpaceXQueries.rockets
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

Contributions are what make the open source community such an amazing place to learn, inspire, and create. 
Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/NewFeature`)
3. Commit your Changes (`git commit -m 'Add some NewFeature'`)
4. Push to the Branch (`git push origin feature/NewFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Code of Conduct

Everyone interacting in the GraphQL DSL project's codebases and issue trackers is expected to 
follow the [code of conduct](https://github.com/maxd/graphql-dsl/blob/master/CODE_OF_CONDUCT.md).
