//
//  LoginViewController.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//

import AuthenticationServices
import UIKit

class LoginViewController: UIViewController {
    private var session: ASWebAuthenticationSession?

    public struct FacebookLoginResponse {
        /// Which permissions has the user granted.
        let grantedPermissionScopes: [String]
        /// An encrypted string unique to each login request. This code must be exchanged for an access token **on your server** using an endpoint.
        /// See [Exchanging Code for an Access Token](https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow#exchangecode).
        let code: String
        /// The state you sent when initializing the request.
        let state: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func LoginButtonDidTapped(_: Any) {
        let facebookAppID: String = Fb.AppID
        // Which permissions you want to access. To see a list of permissions, go to
        // https://developers.facebook.com/docs/facebook-login/permissions/
        let permissionScopes = ["email"]

        // Create a URL to the Facebook login website
        let state = UUID().uuidString
        let callbackScheme = "fb" + facebookAppID
        let urlString = "\(Fb.authURL)"
            + "?client_id=\(facebookAppID)"
            + "&redirect_uri=\(callbackScheme)://authorize"
            + "&scope=\(permissionScopes.joined(separator: ","))"
            + "&response_type=code%20granted_scopes"
            + "&state=\(state)"

        let url = URL(string: urlString)!

        // Initiate an authenticaiton session
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme) { [weak self] url, error in
            guard error == nil else {
              //  print(error!)
                return
            }

            // Try to parse the received URL into FacebookResponse
            guard let receivedURL = url, let response = self?.response(from: receivedURL) else {
                print("Invalid url: \(String(describing: url))")
                return
            }

            // Make sure the state hasn't changed
            guard response.state == state else {
                print("State changed during login! Possible security breach.")
                return
            }
            let token = response.code
            let keyChain = KeyChainWrapperImpl()
            keyChain.setToken(token)

            DispatchQueue.main.async { [weak self] in
                let vc = WeatherViewController()
                if let zipCode = UserDefaults.standard.string(forKey: UserDefaults.zipCodeKey) {
                    vc.zipCode = zipCode
                }
                let naviVC = UINavigationController(rootViewController: vc)
                self?.replaceRootVC(with: naviVC)
            }
        }

        session.presentationContextProvider = self
        session.start()
    }

    func getComponent(named name: String, in items: [URLQueryItem]) -> String? {
        items.first(where: { $0.name == name })?.value
    }

    func response(from url: URL) -> FacebookLoginResponse? {
        guard
            let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
            let state = getComponent(named: "state", in: items),
            let scope = getComponent(named: "granted_scopes", in: items),
            let code = getComponent(named: "code", in: items)
        else {
            return nil
        }

        let grantedPermissions = scope.split(separator: ",").map(String.init)
        return FacebookLoginResponse(
            grantedPermissionScopes: grantedPermissions,
            code: code,
            state: state
        )
    }

   
}

// The View Controller needs to provide the authentication session its window to present the web view
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
