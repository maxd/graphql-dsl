<h1 align="center">✨ GraphQL DSL ✨</h1>

<p align="center">
  <a href="https://github.com/maxd/graphql-dsl/actions/workflows/main.yml"><img src="https://github.com/maxd/graphql-dsl/actions/workflows/main.yml/badge.svg" alt="main" /></a>
  <a href="https://www.ruby-lang.org/en/"><img src="https://img.shields.io/static/v1?label=language&message=Ruby&color=CC342D&style=flat&logo=ruby&logoColor=CC342D" alt="ruby" /></a> 
  <a href="https://graphql.org/"><img src="https://img.shields.io/static/v1?label=language&message=GraphQL&color=E10098&style=flat&logo=graphql&logoColor=E10098" alt="GraphQL" /></a> 
</p>

`graphql-dsl` lets you easy create GraphQL queries by code:

```ruby
extend GraphQL::DSL # Include DSL methods like `query`, `mutation`, etc. 
using GraphQL::DSL  # Include refine methods like `variable` and `directive` if required.

# Query alive characters from Rick and Morty unofficial GraphQL API:
#   https://rickandmortyapi.com/graphql
puts query(:aliveCharacters, species: variable(:String!, 'Human')) {
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

## 🧩 Supported GraphQL features

The GraphQL DSL base on [draft](https://spec.graphql.org/draft/) version of GraphQL specification (updated at Wed, Sep 15, 2021)
and support these features:

- [x] Executable Documents (exclude type system definition documents)
- [x] All operations (`query`, `mutation`, `subscription`) and their features (variable, directives, selection sets, etc.)
- [x] All field features (aliases, arguments, directives, etc.)
- [x] Fragments (include inline fragments)

## ⚙️ Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-dsl', '~> 1.0.0'
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

1. Extend class or module use `GraphQL::DSL` module

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

1. Include `GraphQL::DSL` module to class

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

:bulb: _Non-official SpaceX GraphQL and Rick and Morty APIs are using for most of examples. 
So, you can test generated GraphQL queries [here](https://api.spacex.land/graphql/) and [here](https://rickandmortyapi.com/graphql)._  

### Operations

The GraphQL support three types of operations: 

* `query` - for fetch data.
* `mutation` - for update data.
* `subscription` - for fetch stream of data during a log time.

To create these operations use correspond GraphQL DSL methods: 

* `GraphQL::DSL#query`
* `GraphQL::DSL#mutation`
* `GraphQL::DSL#subscription`

:bulb: _All of them have the same signatures therefore all examples below will use `query` operation._

#### Anonymous operations

Call correspond `GraphQL::DSL` method without any arguments to create anonymous operation:

```ruby
puts GraphQL::DSL.query {
  rockets {
    name
  }
}.to_gql
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

#### Named operations

Use string or symbol to specify operation name:

```ruby
puts GraphQL::DSL.query(:rockets) {
  rockets {
    name
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  query rockets
  {
    rockets
    {
      name
    }
  }
  ```
</details>

#### Parameterized operations

Pass variable definitions to second argument of correspond `GraphQL::DSL` method:

```ruby
using GraphQL::DSL # Include refined `variable` method

puts GraphQL::DSL.query(:capsules, type: :String, status: variable(:String!, 'active')) {
  capsules(find: { type: :$type, status: :$status }) {
    type
    status
    landings
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  query capsules($type: String, $status: String! = "active")
  {
    capsules(find: {type: $type, status: $status})
    {
      type
      status
      landings
    }
  }
  ```
</details>

Choose appropriate notation to define variable type, default value and directives:

:bulb: _See more about types definition [here](#types)._

<details>
  <summary>Use <code>Symbol</code> or <code>String</code></summary>
  
  ```ruby
  # <variable name>: <type>, ...

  puts GraphQL::DSL.query(:capsules, status: :String!) {
    capsules(find: { status: :$status }) {
      type
      status
      landings
    }
  }.to_gql
  ```

  ```graphql
  query capsules($status: String!)
  {
    capsules(find: {status: $status})
    {
      type
      status
      landings
    }
  }
  ```
</details>

<details>
  <summary>Use <code>variable</code> refined method</summary>
  
  ```ruby
  # <variable name>: variable(<type>, [<default value>], [<directives>]), ...

  using GraphQL::DSL # Required to refine `variable` method

  puts GraphQL::DSL.query(:capsules, status: variable(:String!, 'active')) {
    capsules(find: { status: :$status }) {
      type
      status
      landings
    }
  }.to_gql
  ```

  ```graphql
  query capsules($status: String! = "active")
  {
    capsules(find: {status: $status})
    {
      type
      status
      landings
    }
  }
  ```
</details>

<details>
  <summary>Use <code>__var</code> method</summary>

  ```ruby
  # __var <variable name>, <type>, [default: <default value>], [directives: <directives>]

  puts GraphQL::DSL.query(:capsules) {
     __var :status, :String!, default: "active"
     
    capsules(find: { status: :$status }) {
      type
      status
      landings
    }
  }.to_gql
  ```

  ```graphql
  query capsules($status: String! = "active")
  {
    capsules(find: {status: $status})
    {
      type
      status
      landings
    }
  }
  ```
</details>

:bulb: _More information about directives you can find [here](#directives)._

#### Operation's directives

Pass operation's directives to third argument of correspond `GraphQL::DSL` method:

```ruby
using GraphQL::DSL # Include refined `variable` and `directive` methods

puts GraphQL::DSL.query(:capsules, { status: variable(:String!, 'active') }, [ directive(:priority, level: :LOW) ]) {
  capsules(find: { status: :$status }) {
    type
    status
    landings
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  query capsules($status: String! = "active") @priority(level: LOW)
  {
    capsules(find: {status: $status})
    {
      type
      status
      landings
    }
  }
  ```
</details>

:bulb: _More information about directives you can find [here](#directives)._

### Selection Sets

[Selection Set](https://spec.graphql.org/draft/#sec-Selection-Sets) is a block that contains fields, spread or
internal fragments. Operations (`query`, `mutation`, `subscription`), fragment operations, spread and internal fragments 
must have `Selection Set` for select or update (in case of mutation) data. Even a field can contains `Selection Set`. 

```ruby
puts GraphQL::DSL.query {    # this is `Selection Set` of query
  company {                  # this is `Selection Set` of `company` field
    name
    ceo
    cto
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  {
    company
    {
      name
      ceo
      cto
    }
  }
  ```
</details>

### Fields

[Selection Set](#selection-set) should contains one or more fields to select or update (in case of mutation) data.

To create field just declare it name inside of `Selection Set` block:

```ruby
puts GraphQL::DSL.query {    
  company {                  # this is `company` field
    name                     # this is `name` fields declared in `Selection Set` of `company` field 
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  {
    company
    {
      name
    }
  }
  ```
</details>

As you can see above some fields can have `Selection Set` and allow to declare sub-fields. 

In rare cases will be impossible to declare field in such way because its name can conflict with Ruby's keywords and 
methods. In this case you can declare field use `__field` method:

```ruby
# __field <name>, [__alias: <alias name>], [__directives: <directives>], [<arguments>]

puts GraphQL::DSL.query {
  __field(:class) {          # `class` is Ruby's keyword
     __field(:object_id)     # `object_id` is `Object` method
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  {
    class
    {
      object_id
    }
  }
  ```
</details>

To rename field in GraphQL response specify alias in `__alias` argument:

```ruby
puts GraphQL::DSL.query {
  company {
     name __alias: :businessName
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  {
    company
    {
      businessName: name
    }
  }
  ```
</details>

Some field can accept arguments and change their data base on them:

```ruby
puts GraphQL::DSL.query {
  company {
    revenue currency: :RUB   # convert revenue value to Russian Rubles
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  {
    company
    {
      revenue(currency: RUB)
    }
  }
  ```
</details>

Any field can have directives. Pass them though `__directives` argument:

```ruby
using GraphQL::DSL # Required to refine `directive` method

puts GraphQL::DSL.query(:company, additionalInfo: :Boolean) {
  company {
    name 
    revenue __directives: [ directive(:include, if: :$additionalInfo) ]
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  query company($additionalInfo: Boolean)
  {
    company
    {
      name
      revenue @include(if: $additionalInfo)
    }
  }
  ```
</details>

### Executable Documents

Executable Document helps to union several operations or fragments to one request:

```ruby
puts GraphQL::DSL.executable_document {
  query(:companies) {
    company {
      name
    }
  }
  
  query(:rockets) {
    rockets {
      name
    }
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  query companies
  {
    company
    {
      name
    }
  }
  
  query rockets
  {
    rockets
    {
      name
    }
  }
  ```
</details>

### Fragments

Fragments may contains common repeated selections of fields and can be reused in different operations.
Each fragment must have a name, type and optional directives.

:bulb: _See more about type definitions [here](#types)._

```ruby
# fragment(<fragment name>, <type>, [<directives>])

fragment(:ship, :Ship) {
  id
  name
}
```

Fragment spread is using to insert fragment to other operations or fragments. Use `__frgment` command to create fragment
spread and insert fragment by its name.

```ruby
# __fragment(<fragment name>, [__directives: <directives>])

puts GraphQL::DSL.executable_document {
  query(:cargo_ships) {
    ships(find: { type: "Cargo" }) {
      __fragment :ship
    }
  }
  query(:barges) {
    ships(find: { type: "Barge" }) {
      __fragment :ship
    }
  }
  
  fragment(:ship, :Ship) {
    id
    name
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  query cargo_ships
  {
    ships(find: {type: "Cargo"})
    {
      ...ship
    }
  }
  
  query barges
  {
    ships(find: {type: "Barge"})
    {
      ...ship
    }
  }
  
  fragment ship on Ship
  {
    id
    name
  }
  ```
</details>

### Inline fragments

Inline fragments helps to define fields from heterogeneous collections 
(collections which can contains different types of objects). Use `__inline_fragment` to insert inline fragment 
to operation or fragment.

:bulb: _See more about type definitions [here](#types)._

```ruby
# __inline_fragment([<type>]) { Selections Set }

puts GraphQL::DSL.query {
  messages {
    __inline_fragment(:AdSection) {
      title
      image
    }
    
    __inline_fragment(:MessageSection) {
      title
      message
      author
    }
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  {
    messages
    {
      ... on AdSection
      {
        title
        image
      }
      ... on MessageSection
      {
        title
        message
        author
      }
    }
  }
  ```
</details>

Inline fragments may also be used to apply a directive to a group of fields:

```ruby
using GraphQL::DSL # Required to refine `directive` method

# __inline_fragment([<type>]) { Selections Set }

puts GraphQL::DSL.query(:company, additionalInfo: :Boolean) {
  company {
    name
    
    __inline_fragment(nil, __directives: [ directive(:include, if: :$additionalInfo) ]) {
      revenue
      valuation
    }
  }
}.to_gql
```

<details>
  <summary>STDOUT</summary>

  ```graphql
  query company($additionalInfo: Boolean)
  {
    company
    {
      name
      ... @include(if: $additionalInfo)
      {
        revenue
        valuation
      }
    }
  }
  ```
</details>

### Directives

:warning: Non-official SpaceX GraphQL API doesn't support any directives therefore examples below will be fail with error.

Choose appropriate notation to define directive:

<details>
  <summary>Use <code>Symbol</code> or <code>String</code></summary>

  ```ruby
  # (:<name> | "name"), ...
   
  puts GraphQL::DSL.query(:rockets, {}, [ :lowPriority ]) {
     rockets {
        name
     }
  }.to_gql
  ```

  ```graphql
  query rockets @lowPriority
  {
    rockets
    {
      name
    }
  }
  ```
</details>

<details>
  <summary>Use refined <code>directive</code> method</summary>

  ```ruby
  # directive(<directive name>, [<arguments>]), ...

  using GraphQL::DSL # Include refined `directive` method

  puts GraphQL::DSL.query(:rockets, {}, [ directive(:lowPriority) ]) {
     rockets {
        name
     }
  }.to_gql
  ```

  ```graphql
  query rockets @lowPriority
  {
    rockets
    {
      name
    }
  }
  ```
</details>

### Types

Types for operation variables and fragments may be declared in several ways in GraphQL DSL.

#### Named Types

Named Type can be declared like a symbol or string, for instance: `:Int`, `'Int'` 

#### List Types

List Type can be declared like a string only, for instance: `'[Int]'`

#### Not Null Types

Not Null Type can be declared like a string or symbol, for instance: `:Int!`, `'Int!'`, `'[Int!]!'`

## 🚲 Example

[graphql-dsl-example](https://github.com/maxd/graphql-dsl-example) shows how to use GraphQL DSL in Ruby applications.

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
