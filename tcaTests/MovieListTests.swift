import Combine
import ComposableArchitecture
import XCTest
@testable import ComposableArchitecture_Test

class MovieListTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testList() {
        let store = TestStore(
            initialState: MovieListState(),
            reducer: movieListReducer,
            environment: MovieListEnvironment(
                client: .mock(),
                mainQueue: self.scheduler.eraseToAnyScheduler()
            )
        )

        store.assert(
            .environment {
                $0.client.getNowPlaying = { _ in Effect(value: mockMovieResponse) }
            },
            .send(.moviesRequest) {
                $0.currentPage = 1
            },
            .do { self.scheduler.advance(by: 0.3) },
            .receive(.moviesResponse(.success(mockMovieResponse.movies))) {
                $0.movies = IdentifiedArrayOf<Movie>(mockMovieResponse.movies)
            }
        )
    }
}

let mockMovieResponse = MovieResponse(
    movies: [.mock,.mock,.mock]
)
