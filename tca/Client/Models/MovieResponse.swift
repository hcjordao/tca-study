import Foundation

struct MovieResponse: Decodable {
    let movies: [Movie]
}

struct Movie: Decodable, Equatable, Identifiable {
    let popularity: Double
    let voteCount: Int
    let hasVideo: Bool
    let posterPath: String
    let id: Int
    let isAdult: Bool
    let backdropPath: String?
    let language: String
    let originalTitle: String
    let genreIDs: [Int]
    let title: String
    let voteAverage: Double
    let overview: String
    let releaseDate: String
}

extension MovieResponse {
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

extension Movie {
    private enum CodingKeys: String, CodingKey {
        case popularity = "popularity"
        case voteCount = "vote_count"
        case hasVideo = "video"
        case posterPath = "poster_path"
        case id = "id"
        case isAdult = "adult"
        case backdropPath = "backdrop_path"
        case language = "original_language"
        case originalTitle = "original_title"
        case genreIDs = "genre_ids"
        case title = "title"
        case voteAverage = "vote_average"
        case overview = "overview"
        case releaseDate = "release_date"
    }
}

#if DEBUG
extension MovieResponse {
    static let mock: Self = .init(
        movies: [
            .mock,
            .mock,
            .mock
        ]
    )
}

extension Movie {
    static let mock: Self = .init(
        popularity: 2.0,
        voteCount: 40,
        hasVideo: true,
        posterPath: "mock string",
        id: 1,
        isAdult: false,
        backdropPath: "mock poster",
        language: "en",
        originalTitle: "Mock Movie Original Title",
        genreIDs: [1,2,3],
        title: "Mock Movie",
        voteAverage: 20.0,
        overview: "Overview Text",
        releaseDate: "Today"
    )
}
#endif
