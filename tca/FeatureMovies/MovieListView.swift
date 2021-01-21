import ComposableArchitecture
import SwiftUI

struct MovieListState: Equatable {
    var movies: IdentifiedArrayOf<Movie> = []
    var isSheetPresented = false
    var selectedMovie: MovieState?
    var currentPage: Int = 0
}

enum MovieListAction: Equatable {
    case moviesRequest
    case moviesResponse(Result<[Movie], MovieClient.Failure>)
    case movieTapped(Movie)
    case setSheet(isPresented: Bool)
    case presentMovie(MovieAction)
}

struct MovieListEnvironment {
    var client: MovieClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let movieListReducer = movieReducer
    .optional
    .pullback(
        state: \.selectedMovie,
        action: /MovieListAction.presentMovie,
        environment: { environtment in MovieEnvironment(mainQueue: environtment.mainQueue) }
    )
    .combined(
        with: Reducer<MovieListState, MovieListAction, MovieListEnvironment> {
            state, action, environment in
            switch action {
            case .moviesRequest:
                struct MoviesRequestId: Hashable {}
                state.currentPage += 1

                return environment.client.getNowPlaying(state.currentPage)
                    .map(\.movies)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(MovieListAction.moviesResponse)
                    .cancellable(id: MoviesRequestId(), cancelInFlight: false)

            case .moviesResponse(.failure):
                state.movies = []
                return .none

            case let .moviesResponse(.success(response)):
                state.movies.append(contentsOf: response)
                return .none

            case let .movieTapped(movie):
                state.selectedMovie = .init(movie: movie)

                return Effect(value: .setSheet(isPresented: true))
                    .delay(for: 1, scheduler: environment.mainQueue)
                    .eraseToEffect()

            case let .setSheet(isPresented):
                state.isSheetPresented = isPresented
                return .none

            case .presentMovie:
                return .none
            }
        }
    )

struct MovieListView: View {
    let store: Store<MovieListState, MovieListAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack() {
                    if viewStore.movies.isEmpty {
                        ActivityIndicator()
                    } else {
                        List {
                            ForEach(viewStore.movies, id: \.id) { movie in
                                HStack {
                                    Text(movie.title)
                                    Spacer()
                                    Text(movie.releaseDate)
                                }
                                .onTapGesture { viewStore.send(.movieTapped(movie)) }
                                .sheet(
                                    isPresented: viewStore.binding(
                                        get: { $0.isSheetPresented },
                                        send: MovieListAction.setSheet(isPresented:)
                                    )
                                ) {
                                    IfLetStore(
                                        self.store.scope(state: { $0.selectedMovie }, action: MovieListAction.presentMovie),
                                        then: MoviewDetailView.init(store:),
                                        else: ActivityIndicator()
                                    )
                                }

                            }

                            Button(
                                action: { viewStore.send(.moviesRequest) },
                                label: {
                                    Text("Load More")
                                }
                            )
                        }
                    }
                }
                    .navigationBarTitle("Now Playing")
            }
            .onAppear { viewStore.send(.moviesRequest) }
        }
    }
}

#if DEBUG
struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: MovieListState(),
            reducer: movieListReducer,
            environment: MovieListEnvironment(
                client: MovieClient(
                    getNowPlaying: { _ in
                        Effect(value: MovieResponse.mock)
                    }
                ),
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )

        return MovieListView(store: store)
    }
}
#endif
