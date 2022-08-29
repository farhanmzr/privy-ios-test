//
//  LoginController.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 22/06/22.
//

import Foundation
import UIKit

class LoginController : UIViewController {
    
    
    var userToken: UserToken?
    var userData: UserData?
    var apiService: ApiService
    
    init(){
      self.apiService = ApiService.shared(NetworkServiceConcrete())
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
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
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(clickLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var registerLabel: UILabel = {
        let registerLabel = UILabel()
        registerLabel.text = "Register Here"
        registerLabel.textColor = .black
        registerLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        //setup clickable
        return registerLabel
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "is_authenticated"){
            let viewcontroller = ProfileController()
            viewcontroller.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    
    private func setupActivityIndicator() {
      view.addSubview(activityIndicator)
      view.bringSubviewToFront(activityIndicator)
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    private func setupTextFields() {
            
        let stackView = UIStackView(arrangedSubviews: [loginLabel, phoneTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //add stack view as subview to main view with AutoLayout
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 240),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        view.addSubview(registerLabel)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            registerLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginController.clickRegister))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTextChange() {
            
        let phoneText = phoneTextField.text!
        let passwordText = passwordTextField.text!
            
        let isFormFilled = !phoneText.isEmpty && !passwordText.isEmpty
            
        if isFormFilled {
            loginButton.backgroundColor = UIColor.systemBlue
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = UIColor.lightGray
            loginButton.isEnabled = false
        }
            
    }
    
    @objc func clickLogin() {
        
        guard let phoneText = phoneTextField.text, !phoneText.isEmpty else { return }
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else { return }
        
        startLogin(phone: phoneText, password: passwordText)
    }
    
    @objc func clickRegister(){
        let viewController = RegisterController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
        
    func startLogin(phone: String, password: String) {
        
        activityIndicator.startAnimating()
        
        let params: [String: Any] = [
          "phone": phone,
          "password": password,
          "latlong": "null",
          "device_token": "devicetoken1",
          "device_type": 0
        ]
        
        apiService.userSignIn(params: params) { result in
            switch result {
            case .failure(let error):
                print("Sign in Error: ", error.description)
                self.activityIndicator.stopAnimating()
            case .success(let usersToken):
                self.activityIndicator.stopAnimating()
                self.userToken = usersToken
                print("Sign In success")
                print("users token data: ", usersToken)
                let def = UserDefaults.standard
                def.set(true, forKey: "is_authenticated") // save true flag to UserDefaults
                def.set(usersToken.accessToken, forKey: "userAccessToken")
                def.synchronize()
                let viewcontroller = ProfileController()
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
        }
    }
    
//    func goToProfile(usersToken: UserToken){
//        let params: [String: Any] = [
//            "access_token": usersToken.accessToken
//        ]
//        apiService.getCredentials(params: params, accessToken: usersToken.accessToken) { result in
//            switch result {
//            case .failure(let error):
//                print("Credentials Error: ", error.description)
//            case .success(let usersData):
//                self.userData = usersData
//                print("Success get credentials")
//                print("usersData: ", usersData)
//
//            }
//        }
//    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
