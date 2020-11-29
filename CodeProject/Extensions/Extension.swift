//
//  Extension.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//

import UIKit

public extension UIStoryboard {
    static var main: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}


extension UIViewController {
    func replaceRootVC(with vc: UIViewController) {
        if let window = UIApplication.shared.windows.first(where: \.isKeyWindow) {
            window.rootViewController = vc
        }
    }

    func showAlert(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        alertController.preferredAction = alertController.actions[0]
        present(alertController, animated: true, completion: nil)
    }
}

extension UserDefaults {
    static let zipCodeKey = "zipCode"
}


public extension UIStackView {
    convenience init(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0.0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}

public enum ErrorType: Error {
        case searchFail, nodata, decodeFail
    }

extension ErrorType: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .searchFail:
            return NSLocalizedString("Endpoint Error.", comment: "")
        case .decodeFail:
            return NSLocalizedString("Data decode fail.", comment: "")
        case .nodata:
            return NSLocalizedString("no data return", comment: "")
        }
    }
}
