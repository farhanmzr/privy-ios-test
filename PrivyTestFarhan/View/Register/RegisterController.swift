//
//  RegisterController.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 22/06/22.
//

import Foundation
import UIKit

class RegisterController : UIViewController {
  
    var user : User?

    var apiService: ApiService
    
    init(){
      self.apiService = ApiService.shared(NetworkServiceConcrete())
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  lazy var registrationLabel: UILabel = {
    let label = UILabel()
    label.text = "Registration"
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  
  lazy var phoneTextField: UITextField = {
    let tf = UITextField()
    tf.translatesAutoresizingMaskIntoConstraints = false
    tf.placeholder = "Phone Number"
    tf.borderStyle = .bezel
    tf.textColor = UIColor.black
    tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
    let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
    tf.leftView = paddingView
    tf.leftViewMode = .always
    tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    return tf
  }()
  
  lazy var passwordTextField: UITextField = {
    let tf = UITextField()
    tf.translatesAutoresizingMaskIntoConstraints = false
    tf.placeholder = "Password"
    tf.isSecureTextEntry = true
    tf.borderStyle = .bezel
    tf.textColor = UIColor.black
    tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
    let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
    tf.leftView = paddingView
    tf.leftViewMode = .always
    tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    return tf
  }()
    
  lazy var countryTextField: UITextField = {
    let tf = UITextField()
    tf.translatesAutoresizingMaskIntoConstraints = false
    tf.placeholder = "Country"
    tf.borderStyle = .bezel
    tf.textColor = UIColor.black
    tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
    let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
    tf.leftView = paddingView
    tf.leftViewMode = .always
    tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    return tf
  }()
  
  lazy var registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Register Now", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5
    button.backgroundColor = UIColor.lightGray
    button.addTarget(self, action: #selector(clickRegister), for: .touchUpInside)
    return button
  }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
      let activityIndicator = UIActivityIndicatorView()
      activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
      activityIndicator.style = .large
      return activityIndicator
    }()
  
  override func viewDidLoad() {
    view.backgroundColor = .white
    setupTextFields()
    setupActivityIndicator()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  private func setupTextFields() {
    
    let stackView = UIStackView(arrangedSubviews: [registrationLabel,phoneTextField, passwordTextField, countryTextField, registerButton])
    stackView.axis = .vertical
    stackView.spacing = 24
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    //add stack view as subview to main view with AutoLayout
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.heightAnchor.constraint(equalToConstant: 280),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
      stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
    ])
  }
    
    private func setupActivityIndicator() {
      view.addSubview(activityIndicator)
      view.bringSubviewToFront(activityIndicator)
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
  
  @objc func handleTextChange() {
    
    let phoneText = phoneTextField.text!
    let passwordText = passwordTextField.text!
    let countryText = countryTextField.text!
    
    let isFormFilled = !phoneText.isEmpty && !passwordText.isEmpty && !countryText.isEmpty
    
    if isFormFilled {
      registerButton.backgroundColor = UIColor.systemBlue
      registerButton.isEnabled = true
    }else {
      registerButton.backgroundColor = UIColor.lightGray
      registerButton.isEnabled = false
    }
    
  }
  
  @objc func clickRegister() {
      activityIndicator.startAnimating()
    guard let phoneText = phoneTextField.text, !phoneText.isEmpty else { return }
    guard let passwordText = passwordTextField.text, !passwordText.isEmpty else { return }
    guard let countryText = countryTextField.text, !countryText.isEmpty else { return }
    
    startRegister(phone: phoneText,
                  password: passwordText,
                  country: countryText,
                  latlong: "123123",
                  device_token: "devicetoken1",
                  device_type: 0)
  }
  
  func startRegister(phone: String,
                     password: String,
                     country: String,
                     latlong: String,
                     device_token: String,
                     device_type: Int) {
    
    let params: [String: Any] = [
      "phone": phone,
      "password": password,
      "country": country,
      "latlong": latlong,
      "device_token": device_token,
      "device_type": device_type
    ]
    
    apiService.register(params: params) { result in
        switch result {
        case .failure(let error):
            print("register_error : ", error.description)
            self.activityIndicator.stopAnimating()
            self.presentAlert(title: "Registration Failed!",
                              message: "Register Error : \(error.description)") { _ in }
        case .success(let users):
            self.user = users
            print("user", users)
            self.goToOtp(users: users)
        }
    }
  }
    
    func goToOtp(users: User){
        
        let params: [String: Any] = [
            "phone": users.phone,
        ]
        
        apiService.requestOtp(params: params) { result in
          switch result {
          case .failure(let error):
              print("resend_otp_error : ", error.description)
              self.activityIndicator.stopAnimating()
          case .success(_):
              self.activityIndicator.stopAnimating()
              self.showToast(message: "Please check the Code OTP that entered your number.", font: .systemFont(ofSize: 14))
              let viewcontroller = OtpController()
              viewcontroller.user = users
              self.navigationController?.pushViewController(viewcontroller, animated: true)
          }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


