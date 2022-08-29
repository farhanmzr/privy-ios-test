//
//  EditCareerController.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 26/06/22.
//

import Foundation
import UIKit

class EditCareerController : UIViewController {
    
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
        label.text = "Update Career Data"
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
    
    lazy var positionTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Your Position"
        tf.borderStyle = .bezel
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var companyTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Company Name"
        tf.borderStyle = .bezel
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var startTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Select Starting From Date"
        tf.borderStyle = .bezel
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor(white: 0, alpha: 0.0)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var endTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Select Ending In Date"
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
        button.setTitle("Update Career", for: .normal)
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
        setupTextFields()
        setupActivityIndicator()
        self.startTextField.setInputViewDatePicker(target: self, selector: #selector(startDone))
        self.endTextField.setInputViewDatePicker(target: self, selector: #selector(endDone))
    }
    
    private func setupActivityIndicator() {
      view.addSubview(activityIndicator)
      view.bringSubviewToFront(activityIndicator)
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupTextFields() {
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descLabel, positionTextField, companyTextField, startTextField, endTextField, editButton])
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
    
    @objc func startDone() {
        if let datePicker = self.startTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.startTextField.text = dateformatter.string(from: datePicker.date)
            print(datePicker.date)
        }
        self.startTextField.resignFirstResponder()
    }
    
    @objc func endDone() {
        if let datePicker = self.endTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.endTextField.text = dateformatter.string(from: datePicker.date)
            print(datePicker.date)
        }
        self.endTextField.resignFirstResponder()
    }
    
    @objc func handleTextChange() {
            
        let positionText = positionTextField.text!
        let companyText = companyTextField.text!
        let startText = startTextField.text!
        let endText = endTextField.text!
        
        let isFormFilled = !positionText.isEmpty && !companyText.isEmpty && !startText.isEmpty && !endText.isEmpty
            
        if isFormFilled {
            editButton.backgroundColor = UIColor.systemBlue
            editButton.isEnabled = true
        } else {
            editButton.backgroundColor = UIColor.lightGray
            editButton.isEnabled = false
        }
    }
    
    
    @objc func clickUpdateProfile() {
        guard let positionText = startTextField.text, !positionText.isEmpty else { return }
        guard let companyText = companyTextField.text, !companyText.isEmpty else { return }
        guard let startText = startTextField.text, !startText.isEmpty else { return }
        guard let endText = endTextField.text, !endText.isEmpty else { return }
        
        updateData(position: positionText, companyName: companyText, start: startText, end: endText)
    }
    
    func updateData(position: String, companyName: String, start: String, end: String){
        
        activityIndicator.startAnimating()
        let token = UserDefaults.standard.string(forKey: "userAccessToken")
        print(token ?? "")
        
        let params: [String: Any] = [
          "position": position,
          "company_name": companyName,
          "starting_from": start,
          "ending_in": end,
        ]
        
        apiService.updateCareerData(params: params, accessToken: token ?? "") { result in
            switch result {
                case .failure(let error):
                    self.activityIndicator.stopAnimating()
                    print("Update Career Error: ", error.description)
                case .success(_):
                    self.activityIndicator.stopAnimating()
                    self.presentAlert(title: "Update Succesful",
                                      message: "Successfully Update Career Data") { _ in
                    let viewController = ProfileController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
}
