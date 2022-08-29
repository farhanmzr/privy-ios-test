//
//  OtpController.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 22/06/22.
//

import Foundation
import UIKit

class OtpController : UIViewController {
    
    var apiService: ApiService
    var user: User?
    var codeOtp: String?
    var userToken: UserToken?
    
    init(){
      self.apiService = ApiService.shared(NetworkServiceConcrete())
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    lazy var otpLabel: UILabel = {
        let label = UILabel()
        label.text = "Percobaan OTP"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    lazy var verificationButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Verifikasi", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 5
      button.backgroundColor = UIColor.systemBlue
      button.addTarget(self, action: #selector(verificationOtp), for: .touchUpInside)
      return button
    }()
    
    lazy var resendOtp: UILabel = {
        let label = UILabel()
        label.attributedText = "Resend Code OTP".underLined
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
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
        setupView()
        setupActivityIndicator()
    }
    
    
    private func setupView(){
        
        let newView = OneTimeCodeTextField()
        
        let stackView = UIStackView(arrangedSubviews: [otpLabel, newView, verificationButton])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //add stack view as subview to main view with AutoLayout
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 180),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        newView.configure()
        newView.didEnterLastDigit = { [weak self] code in
            self?.codeOtp = code
            print(code)
        }
        
        view.addSubview(resendOtp)
        resendOtp.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resendOtp.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            resendOtp.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(OtpController.clickResendOtp))
        resendOtp.isUserInteractionEnabled = true
        resendOtp.addGestureRecognizer(tap)
        
    }
    
    private func setupActivityIndicator() {
      view.addSubview(activityIndicator)
      view.bringSubviewToFront(activityIndicator)
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func verificationOtp(){
        activityIndicator.startAnimating()
        guard let user = user else { return }
        let params: [String: Any] = [
            "user_id": user.id,
            "otp_code": codeOtp as Any
        ]
        apiService.matchingOtp(params: params) { result in
            switch result {
            case .failure(let error):
                self.activityIndicator.stopAnimating()
                print("failure matching otp code: ", error.description)
            case .success(let usersToken):
                self.activityIndicator.stopAnimating()
                self.userToken = usersToken
                self.presentAlert(title: "Device Verification", message: "Congratulations, your device is verified. Now you can login") { _ in
                    let viewcontroller = LoginController()
                    viewcontroller.userToken = usersToken
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                }
            }
        }
    }
    
    @objc func clickResendOtp(){
        activityIndicator.startAnimating()
        guard let user = user else { return }
        let params: [String: Any] = [
            "phone": user.phone,
        ]
        
        apiService.requestOtp(params: params) { result in
          switch result {
          case .failure(let error):
            self.activityIndicator.stopAnimating()
            print("resend_otp_error : ", error.description)
          case .success(_):
            self.activityIndicator.stopAnimating()
            self.presentAlert(title: "Resend OTP",
                         message: "Successfully Resend Code OTP. Please wait a minute.") { _ in }
          }
        }
    }
    
}

class OneTimeCodeTextField: UITextField {

    var didEnterLastDigit: ((String) -> Void)?
    
    var defaultCharacter = "x"
    
    private var isConfigured = false
    
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount: Int = 4) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.heightAnchor.constraint(equalToConstant: 72),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            labelsStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            labelsStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
            ])
        
    }

    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            label.backgroundColor = .lightGray
            label.layer.cornerRadius = 8
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    @objc
    private func textDidChange() {
        
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text = defaultCharacter
            }
        }
        
        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        }
    }
    
}

extension OneTimeCodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}

