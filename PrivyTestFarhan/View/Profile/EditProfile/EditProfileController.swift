//
//  EditProfileController.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 26/06/22.
//

import Foundation
import UIKit

class EditProfileController : UIViewController {
    
    var apiService: ApiService
    
    init(){
      self.apiService = ApiService.shared(NetworkServiceConcrete())
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Update Profile Data"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Please fill the form to update your data."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name"
        tf.borderStyle = .bezel
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var birthdayTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Select Date"
        tf.borderStyle = .bezel
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var hometownTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Home Town"
        tf.borderStyle = .bezel
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var bioTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Bio"
        tf.borderStyle = .bezel
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(clickUpdateProfile), for: .touchUpInside)
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
        setupActivityIndicator()
        setupTextFields()
        self.birthdayTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditProfileController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupActivityIndicator() {
      view.addSubview(activityIndicator)
      view.bringSubviewToFront(activityIndicator)
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupTextFields() {
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel, nameTextField, birthdayTextField,
                                                       hometownTextField, bioTextField, editButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //add stack view as subview to main view with AutoLayout
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    @objc func tapDone() {
        if let datePicker = self.birthdayTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.birthdayTextField.text = dateformatter.string(from: datePicker.date)
            print(datePicker.date)
        }
        self.birthdayTextField.resignFirstResponder()
    }
    
    @objc func handleTextChange() {
            
        let nameText = nameTextField.text!
        let birthdayText = birthdayTextField.text!
        let hometownText = hometownTextField.text!
        let bioText = bioTextField.text!
            
        let isFormFilled = !nameText.isEmpty && !birthdayText.isEmpty && !hometownText.isEmpty && !bioText.isEmpty
            
        if isFormFilled {
            editButton.backgroundColor = UIColor.systemBlue
            editButton.isEnabled = true
        } else {
            editButton.backgroundColor = UIColor.lightGray
            editButton.isEnabled = false
        }
    }
    
    
    @objc func clickUpdateProfile() {
        guard let nameText = nameTextField.text, !nameText.isEmpty else { return }
        guard let birthdayText = birthdayTextField.text, !birthdayText.isEmpty else { return }
        guard let hometownText = hometownTextField.text, !hometownText.isEmpty else { return }
        guard let bioText = bioTextField.text, !bioText.isEmpty else { return }
        
        updateData(name: nameText, gender: 0, birthday: birthdayText, hometown: hometownText, bio: bioText)
    }
    
    func updateData(name: String, gender: Int, birthday: String, hometown: String, bio: String){
        
        activityIndicator.startAnimating()
        let token = UserDefaults.standard.string(forKey: "userAccessToken")
        print(token ?? "")
        
        let params: [String: Any] = [
          "name": name,
          "gender": gender,
          "birthday": birthday,
          "hometown": hometown,
          "bio": bio
        ]
        
        apiService.updateProfileData(params: params, accessToken: token ?? "") { result in
            switch result {
                case .failure(let error):
                    self.activityIndicator.stopAnimating()
                    print("Update Profile Error: ", error.description)
                case .success(_):
                    self.activityIndicator.stopAnimating()
                self.presentAlert(title: "Update Succesful",
                                  message: "Successfully Update Profile Data") { _ in
                    let viewController = ProfileController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
