//
//  ProfileController.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 25/06/22.
//

import Foundation
import UIKit
import Alamofire

class ProfileController : UIViewController {
    
    var apiService: ApiService
    var profileData: UserData?
    var imagePicker: ImagePicker!
    
    init(){
      self.apiService = ApiService.shared(NetworkServiceConcrete())
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    lazy var coverImageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFill
      return iv
    }()
    
    lazy var lineView: UIView = {
        let lv = UIView()
        lv.layer.borderColor = UIColor.lightGray.cgColor
        lv.layer.borderWidth = 1
        return lv
    }()
    
    lazy var lineView2: UIView = {
        let lv = UIView()
        lv.layer.borderColor = UIColor.lightGray.cgColor
        lv.layer.borderWidth = 1
        return lv
    }()
    
    lazy var lineView3: UIView = {
        let lv = UIView()
        lv.layer.borderColor = UIColor.lightGray.cgColor
        lv.layer.borderWidth = 1
        return lv
    }()
    
    lazy var lineView4: UIView = {
        let lv = UIView()
        lv.layer.borderColor = UIColor.lightGray.cgColor
        lv.layer.borderWidth = 1
        return lv
    }()
    
    lazy var avatarImageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFill
      iv.layer.cornerRadius = 45
      iv.layer.masksToBounds = true
      return iv
    }()
    
    lazy var nameLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
      label.numberOfLines = 1
      return label
    }()
    
    lazy var genderLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      label.numberOfLines = 1
      return label
    }()
    
    lazy var hometownLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      label.numberOfLines = 1
      return label
    }()
    
    lazy var bioLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
      label.numberOfLines = 1
      return label
    }()
    
    lazy var schoolLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
      label.numberOfLines = 1
      return label
    }()
    
    lazy var graduationLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      label.numberOfLines = 1
      return label
    }()
    
    lazy var companyLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
      label.numberOfLines = 1
      return label
    }()
    
    lazy var startingLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
      label.numberOfLines = 1
      return label
    }()
    
    lazy var endingLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
      label.numberOfLines = 1
      return label
    }()
    
    lazy var editProfilButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Edit Data", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 5
      button.layer.masksToBounds = true
      button.backgroundColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
      button.addTarget(self, action: #selector(clickEditProfile), for: .touchUpInside)
      return button
    }()
    
    lazy var editImageAvatar: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Edit", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 5
      button.layer.masksToBounds = true
      button.backgroundColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
      button.addTarget(self, action: #selector(clickEditAvatar), for: .touchUpInside)
      return button
    }()
    
    lazy var editEducationButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Edit Education Data", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 5
      button.layer.masksToBounds = true
      button.backgroundColor = .systemBlue
      button.addTarget(self, action: #selector(clickEditEducation), for: .touchUpInside)
      return button
    }()
    
    lazy var editCareerButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Edit Career Data", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 5
      button.layer.masksToBounds = true
      button.backgroundColor = .systemBlue
      button.addTarget(self, action: #selector(clickEditCareer), for: .touchUpInside)
      return button
    }()
    
    lazy var logoutButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Logout", for: .normal)
      button.setTitleColor(.black, for: .normal)
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 5
      button.layer.masksToBounds = true
      button.backgroundColor = .clear
      button.layer.borderWidth = 2
      button.layer.borderColor = UIColor.systemBlue.cgColor
      button.addTarget(self, action: #selector(clickLogout), for: .touchUpInside)
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
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        setupActivityIndicator()
        setupCoverImage()
        setupAvatarImage()
        setupProfileData()
        loadDataUser()
    }
    
    @objc func clickEditAvatar() {
        self.imagePicker.present(from: editImageAvatar)
    }
    
    private func loadDataUser(){
        
        let token = UserDefaults.standard.string(forKey: "userAccessToken")
        print(token ?? "")
        
        let params: [String: Any] = ["Authorization":token ?? ""]

        apiService.getProfileData(params: params, accessToken: token ?? "") { result in
            switch result {
            case .failure(let error):
                print("Get Profile Data : ", error.description)
            case .success(let users):
                self.profileData = users
                let coverImage = URL(string: users.coverPicture.url ?? "")
                let defaultImage = URL(string: "https://sanamurad.com/wp-content/themes/miyazaki/assets/images/default-fallback-image.png")
                self.coverImageView.loadImage(url: (coverImage ?? defaultImage)!)
                self.nameLabel.text = users.name ?? "name"
                self.genderLabel.text = users.gender ?? "gender"
                self.hometownLabel.text = users.hometown ?? "hometown"
                self.bioLabel.text = users.bio ?? "bio"
                self.schoolLabel.text = users.education.schoolName ?? "education"
                self.graduationLabel.text = users.education.graduationTime ?? "graduation time"
                self.companyLabel.text = users.career.companyName ?? "companyname"
                self.startingLabel.text = users.career.startingFrom ?? "starting-in"
                self.endingLabel.text = users.career.endingIn ?? "ending-in"
                print("user", users)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupActivityIndicator() {
      view.addSubview(activityIndicator)
      view.bringSubviewToFront(activityIndicator)
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupCoverImage(){
        view.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageView.heightAnchor.constraint(equalToConstant: 160),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        coverImageView.backgroundColor = .red
    }
    
    private func setupAvatarImage(){
        view.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: 16),
            avatarImageView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 60)
        ])
        avatarImageView.backgroundColor = .blue
        
        view.addSubview(editImageAvatar)
        NSLayoutConstraint.activate([
            editImageAvatar.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -8),
            editImageAvatar.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor)
        ])
    }
    
    private func setupProfileData(){
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, genderLabel, hometownLabel, bioLabel])
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 45),
            stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16)
        ])
        
        view.addSubview(editProfilButton)
        NSLayoutConstraint.activate([
            editProfilButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0),
            editProfilButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1.25),
            lineView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        //addSchoolData
        schoolLabel.text = "Universitas Diponegoro"
        graduationLabel.text = "February 2022"
        let stackView2 = UIStackView(arrangedSubviews: [schoolLabel, graduationLabel])
        stackView2.axis = .horizontal
        stackView2.distribution = .fill
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView2)
        NSLayoutConstraint.activate([
            stackView2.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 24),
            stackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(lineView2)
        lineView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView2.heightAnchor.constraint(equalToConstant: 1.25),
            lineView2.topAnchor.constraint(equalTo: stackView2.bottomAnchor, constant: 24),
            lineView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lineView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(companyLabel)
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        companyLabel.text = "Digital Agency"
        NSLayoutConstraint.activate([
            companyLabel.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 24),
            companyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(startingLabel)
        startingLabel.translatesAutoresizingMaskIntoConstraints = false
        startingLabel.text = "28 Mei 2020"
        NSLayoutConstraint.activate([
            startingLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 12),
            startingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(endingLabel)
        endingLabel.translatesAutoresizingMaskIntoConstraints = false
        endingLabel.text = "3 Maret 2021"
        NSLayoutConstraint.activate([
            endingLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 12),
            endingLabel.leadingAnchor.constraint(equalTo: startingLabel.trailingAnchor, constant: 10)
        ])
        
        view.addSubview(lineView3)
        lineView3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView3.heightAnchor.constraint(equalToConstant: 1.25),
            lineView3.topAnchor.constraint(equalTo: endingLabel.bottomAnchor, constant: 24),
            lineView3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lineView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(editEducationButton)
        NSLayoutConstraint.activate([
            editEducationButton.heightAnchor.constraint(equalToConstant: 40),
            editEducationButton.topAnchor.constraint(equalTo: lineView3.bottomAnchor, constant: 32),
            editEducationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            editEducationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
        
        view.addSubview(editCareerButton)
        NSLayoutConstraint.activate([
            editCareerButton.heightAnchor.constraint(equalToConstant: 40),
            editCareerButton.topAnchor.constraint(equalTo: editEducationButton.bottomAnchor, constant: 24),
            editCareerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            editCareerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
        
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 40),
            logoutButton.topAnchor.constraint(equalTo: editCareerButton.bottomAnchor, constant: 24),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
        
        
    }
    
    @objc func clickEditProfile(){
        let viewController = EditProfileController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func clickEditEducation(){
        let viewController = EditEducationController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func clickEditCareer(){
        let viewController = EditCareerController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func clickLogout(){
        activityIndicator.startAnimating()
        
        let token = UserDefaults.standard.string(forKey: "userAccessToken")
        print(token ?? "")
        
        let params: [String: Any] = [
          "access_token": token ?? "",
          "confirm": 1
        ]
        
        apiService.userSignOut(params: params) { result in
            switch result {
                case .failure(let error):
                    self.activityIndicator.stopAnimating()
                    print("Sign Out Error: ", error.description)
                case .success(_):
                    self.activityIndicator.stopAnimating()
                    let viewController = LoginController()
                    self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

extension ProfileController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.avatarImageView.image = image
    }
}
