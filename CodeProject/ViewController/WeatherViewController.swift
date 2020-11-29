//
//  ViewController.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//

import UIKit

class WeatherViewController: UIViewController {
    lazy var zipLabel: UILabel = {
        let v = UILabel()
        v.text = "Zip Code:"
        return v
    }()

    var zipCode = ""

    var zipTextField: UITextField = {
        let v = UITextField(frame: .zero)
        v.textContentType = .postalCode
        v.keyboardType = .numbersAndPunctuation
        v.borderStyle = .roundedRect
        v.returnKeyType = UIReturnKeyType.done
        v.placeholder = "zip"
        return v
    }()

    lazy var temperatureLabel: UILabel = {
        let v = UILabel()
        v.text = "Temperature:"
        v.font = UIFont.preferredFont(forTextStyle: .headline)
        return v
    }()

    lazy var valueLabel: UILabel = {
        let v = UILabel()
        v.text = "--"
        v.font = UIFont.preferredFont(forTextStyle: .headline)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        configUI()
        if zipCode.count > 0 {
            getWeather(for: zipCode)
        }
    }


    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action:  #selector(Logout))
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func Logout() {
        let keyChain = KeyChainWrapperImpl()
        keyChain.removeToken()

        guard let vc = UIStoryboard.main?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return 
        }
        replaceRootVC(with: vc)
    }

    func configUI() {
        zipTextField.text = zipCode
        zipTextField.delegate = self
        let hStackView1 = UIStackView(arrangedSubviews: [zipLabel, zipTextField], axis: .horizontal, spacing: 10, alignment: .center)
        hStackView1.distribution = .fillEqually

        let hStackView2 = UIStackView(arrangedSubviews: [temperatureLabel, valueLabel], axis: .horizontal, spacing: 10, alignment: .center)
        hStackView2.distribution = .fillEqually

        let vStackView = UIStackView(arrangedSubviews: [hStackView1, hStackView2], axis: .vertical, spacing: 10, alignment: .fill)

        view.addSubview(vStackView)

        vStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            vStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            vStackView.heightAnchor.constraint(equalToConstant: 60),
            vStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        ])
    }
}


extension WeatherViewController: UITextFieldDelegate {
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Prevent non-number char
        if string == "\n" {
            textField.resignFirstResponder()
            return true
        }
        let allowedCharacters = CharacterSet(charactersIn:"0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let zipCode = textField.text else { return }
        UserDefaults.standard.set(zipCode, forKey: UserDefaults.zipCodeKey)
        getWeather(for: zipCode)
    }


    func getWeather(for zipCode: String) {
        OpenWeatherServices.weather(type: .zipcode(zip: zipCode)) { [weak self] (result: Result<WeatherModel, ErrorType>) in
            var degree = ""
            switch result {
            case .success(let weather):
                degree = String(format: "%.1f F",weather.main.temp)
            case .failure(let error):
                degree = error.localizedDescription
            }
            DispatchQueue.main.async {
                self?.valueLabel.text = degree
            }
        }
    }
}
