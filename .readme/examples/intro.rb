puts executable_document {
  query(:alive_characters, species: [:String!, 'Human']) {
    characters(filter: { status: 'Alive', species: :$species }) {
      results {
        name
        image
      }
    }
  }
}.to_gql
