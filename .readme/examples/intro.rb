puts executable_document {
  query(:alive_and_dead_characters, { species: [:String!, 'Human'] }) {
    characters(__alias: :alive, filter: { status: 'Alive', species: :$species }) {
      __fragment :short_info_about_characters
    }

    characters(__alias: :dead, filter: { status: 'Dead', species: :$species }) {
      __fragment :short_info_about_characters

      results {
        location(__alias: :last_known_location) {
          name
        }
      }
    }
  }

  fragment(:short_info_about_characters, :Characters) {
    results {
      name
      image
    }
  }
}.to_gql
