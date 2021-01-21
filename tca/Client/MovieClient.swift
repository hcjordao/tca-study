import ComposableArchitecture
import Foundation

struct MovieClient {
    var getNowPlaying: (Int) -> Effect<MovieResponse, Failure>

    struct Failure: Error, Equatable {}
}

extension MovieClient {
    static let instance = MovieClient(
        getNowPlaying: { movieID in
            URLSession
                .shared
                .dataTaskPublisher(for: URL(string: APIEndpoints.latest(page: movieID))!)
                .map { data, _ in data }
                .decode(type: MovieResponse.self, decoder: JSONDecoder())
                .mapError { _ in Failure() }
                .eraseToEffect()
        }
    )
}

extension MovieClient {
  static func mock(
    getNowPlaying: @escaping (Int) -> Effect<MovieResponse, Failure> = { _ in
      fatalError("Unmocked")
    }
  ) -> Self {
    Self(
      getNowPlaying: getNowPlaying
    )
  }
}
