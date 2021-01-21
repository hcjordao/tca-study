import Foundation

enum APICredentials {
    static let key = "78179838ce3f87a2cb913802cd1b8bbe"
    static let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ODE3OTgzOGNlM2Y4N2EyY2I5MTM4MDJjZDFiOGJiZSIsInN1YiI6IjVlOTg2MDFjZjY1OTZmMDAxMmNkYTEwYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Js3LKoGUwdndMfJ0eWSyBSifV3nJVGvkLYlvkZlu6Y8"
}

enum APIEndpoints{
    static let baseURL = "https://api.themoviedb.org/3"
    static func latest(page: Int) -> String {
        baseURL + "/movie/now_playing?api_key=\(APICredentials.key)&page=\(page)"
    }
}
