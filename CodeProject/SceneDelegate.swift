//
//  SceneDelegate.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let keyChain = KeyChainWrapperImpl()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        checkIfUserLoggedin()
    }

    func checkIfUserLoggedin() {
        if keyChain.hasToken() {
            // User is already Loggedin
            let vc = WeatherViewController()
            let navi = UINavigationController(rootViewController: vc)
            window?.rootViewController = navi

        } else {
            // User is not loggedin
            let vc = UIStoryboard.main?.instantiateViewController(withIdentifier: "LoginViewController")
            window?.rootViewController = vc
        }
        window?.makeKeyAndVisible()
    }
}
