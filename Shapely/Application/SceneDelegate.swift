//
//  SceneDelegate.swift
//  Shapely
//
//  Created by Andrew on 11.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appAssembly: AppAssembly?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        self.appAssembly = AppAssembly(window: window)
        setupWindow()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    private func setupWindow() {
        guard let appAssembly = appAssembly else { return }
        appAssembly.initializeModules()
        window?.makeKeyAndVisible()
        window?.rootViewController = appAssembly.container.resolve(UIViewController.self, name: "mainController")!
    }
}
