import ComposableArchitecture
import SwiftUI

struct MovieState: Equatable {
    var movie: Movie
}

enum MovieAction: Equatable {
    case dummyAction
}

struct MovieEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let movieReducer = Reducer<MovieState, MovieAction, MovieEnvironment> {
    state, action, environment in
    switch action {
    case .dummyAction:
        return .none
    }
}

struct MoviewDetailView: View {
    let store: Store<MovieState, MovieAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    Section(header: Text(viewStore.movie.title).font(.largeTitle)) {
                        self.detailRow(title: "popularity", subtitle: viewStore.movie.popularity.toString())
                        self.detailRow(title: "voteCount", subtitle: viewStore.movie.voteCount.toString())
                        self.detailRow(title: "hasVideo", subtitle: viewStore.movie.hasVideo.toString())
                        self.detailRow(title: "posterPath", subtitle: viewStore.movie.posterPath)
                        self.detailRow(title: "id", subtitle: viewStore.movie.id.toString())
                        self.detailRow(title: "isAdult", subtitle: viewStore.movie.isAdult.toString())
                        self.detailRow(title: "backdropPath", subtitle: viewStore.movie.backdropPath ?? "")
                        self.detailRow(title: "language", subtitle: viewStore.movie.language)
                        self.detailRow(title: "originalTitle", subtitle: viewStore.movie.originalTitle)
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Movie Info", displayMode: .inline)
            }
        }
    }

    private func detailRow(title: String, subtitle: String) -> some View {
        HStack {
            Text(title)
                .font(.body)
            Spacer()
            Text(subtitle)
                .font(.footnote)
        }
    }
}

#if DEBUG
struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("Detail :)")
    }
}
#endif
