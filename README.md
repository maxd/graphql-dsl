<h1 align="center">✨ GraphQL DSL ✨</h1>

<p align="center">
  <a href="https://github.com/maxd/graphql-dsl/actions/workflows/main.yml"><img src="https://github.com/maxd/graphql-dsl/actions/workflows/main.yml/badge.svg" alt="main" /></a>
  <a href="https://www.ruby-lang.org/en/"><img src="https://img.shields.io/static/v1?label=language&message=Ruby&color=CC342D&style=flat&logo=ruby&logoColor=CC342D" alt="ruby" /></a> 
  <a href="https://graphql.org/"><img src="https://img.shields.io/static/v1?label=language&message=GraphQL&color=E10098&style=flat&logo=graphql&logoColor=E10098" alt="GraphQL" /></a> 
</p>

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

## ⚙️ Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-dsl', '~> 0.1.0'
```

And then execute `bundle install`.

## ⚡️ Getting Started

Choose an appropriate way to use GraphQL DSL:

1. Call methods of `GraphQL::DSL` module directly

    ```ruby
    rockets_query = GraphQL::DSL.query {
      rockets {
        name
      }
    }.to_gql
    
    puts rockets_query
    ```

    <details>
      <summary>STDOUT</summary>

      ```graphql
      {
        rockets
        {
          name
        }
      }
      ```
    </details>

1. Extend class or module with `GraphQL:DSL` module

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

    <details>
      <summary>STDOUT</summary>

      ```graphql
      {
        rockets
        {
          name
        }
      }
      ```
    </details>

    ```ruby
    module SpaceXQueries
      extend GraphQL::DSL
   
      # `extend self` or `module_function` required to 
      # call of `SpaceXQueries.rockets`
      extend self    
   
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

    <details>
      <summary>STDOUT</summary>

      ```graphql
      {
        rockets
        {
          name
        }
      }
      ```
    </details>

1. Include `GraphQL:DSL` module to class

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

    <details>
      <summary>STDOUT</summary>

      ```graphql
      {
        rockets
        {
          name
        }
      }
      ```
    </details>

## 👀 Examples

SpaceX GraphQL API has been used for examples. So, you can test generated GraphQL queries [here](https://api.spacex.land/graphql/).  

### Queries

#### Anonymous query

Call `GraphQL::DSL#query` method without any arguments to create anonymous query:

```ruby
puts GraphQL::DSL.query {
   rockets {
      name
   }
}.to_gql
```

```graphql
{
  rockets
  {
    name
  }
}
```

#### Named query

Use strings or symbols to declare query name:

```ruby
puts GraphQL::DSL.query(:rockets) {
   rockets {
      name
   }
}.to_gql
```

```graphql
query rockets
{
  rockets
  {
    name
  }
}
```

#### Parameterized query

Pass variable definitions to second argument of `GraphQL::DSL#query` method:

```ruby
puts GraphQL::DSL.query(:rockets, limit: [:Int!, 3]) {
   rockets(limit: :$limit) {
      name
   }
}.to_gql
```

```graphql
query rockets($limit: Int! = 3)
{
  rockets(limit: $limit)
  {
    name
  }
}
```

Choose appropriate notation to define variable type, default value and directives:

* Use `String`:
    ```ruby
    # variable: "<type>", ...
  
    puts query(:users, user_ids: "[Int!]", active: "Boolean") {
      users(user_ids: :$user_ids, active: :$active) {
        id
        name
      }
    }.to_gql
    ```

    ```graphql
    query users($user_ids: [Int!], $active: Boolean)
    {
      users(user_ids: $user_ids, active: $active)
      {
        id
        name
      }
    }
    ```
* Use `Symbol`:
    ```ruby
    # variable: :<type>, ...
  
    puts query(:user, id: :Int!) {
      user(id: :$id) {
        id
        name
      }
    }.to_gql
    ```

    ```graphql
    query user($id: Int!)
    {
      user(id: $id)
      {
        id
        name
      }
    }
    ```
* Use `Array`: 
    ```ruby
    # variable: [<type>, <default value>, <directives>], ...
    
    puts query(:movies, genre: [:Genre, :ACTION]) {
      movies(genre: :$genre) {
        title
      }
    }.to_gql
    ```

    ```graphql
    query movies($genre: Genre = ACTION)
    {
      movies(genre: $genre)
      {
        title
      }
    }
    ```
* Use `Hash`:
    ```ruby
    # variable: { 
    #   type: <type>, 
    #   default: <default value>, 
    #   directives: <directives>
    # }, ...
  
    puts query(:movies, genre: { type: :Genre, default: :ACTION }) {
      movies(genre: :$genre) {
        title
      }
    }.to_gql
    ```

    ```graphql
    query movies($genre: Genre = ACTION)
    {
      movies(genre: $genre)
      {
        title
      }
    }
    ```

## 💻 Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To release a new version:

* update the version number in `lib/graphql/dsl/version.rb` file
* run `bundle exec rake readme:update` to update `README.md` file 
* run `bundle exec rake release` to create a git tag for the version, push git commits and the created tag, 
  and push the `.gem` file to [rubygems.org](https://rubygems.org).

## 👍 Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. 
Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/NewFeature`)
3. Commit your Changes (`git commit -m 'Add some NewFeature'`)
4. Push to the Branch (`git push origin feature/NewFeature`)
5. Open a Pull Request

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🥰 Code of Conduct

Everyone interacting in the GraphQL DSL project's codebases and issue trackers is expected to 
follow the [code of conduct](https://github.com/maxd/graphql-dsl/blob/master/CODE_OF_CONDUCT.md).

## 📚 Resources

* [Introduction to GraphQL](https://graphql.org/learn/)
* [GraphQL Specification](https://spec.graphql.org/)
