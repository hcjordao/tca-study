import ComposableArchitecture
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        self.window = (scene as? UIWindowScene).map(UIWindow.init(windowScene:))
        self.window?.rootViewController = UIHostingController(
            rootView: MovieListView(
                store: Store(
                    initialState: MovieListState(),
                    reducer: movieListReducer.debug(),
                    environment: MovieListEnvironment(
                        client: MovieClient.instance,
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                    )
                )
            )
        )

        window?.makeKeyAndVisible()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    true
  }
}
