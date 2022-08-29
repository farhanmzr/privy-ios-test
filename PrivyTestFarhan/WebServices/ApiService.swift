//
//  ApiService.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 24/06/22.
//

import Foundation
import Alamofire

private let urlRegister = "http://pretest-qa.dcidev.id/api/v1/register"
private let urlRequestOtp = "http://pretest-qa.dcidev.id/api/v1/register/otp/request"
private let urlOtpMatch = "http://pretest-qa.dcidev.id/api/v1/register/otp/match"
private let urlSignIn = "http://pretest-qa.dcidev.id/api/v1/oauth/sign_in"
private let baseUrlCredentials = "http://pretest-qa.dcidev.id/api/v1/oauth/credentials?access_token="

private let urlProfileData = "http://pretest-qa.dcidev.id/api/v1/profile/me"

private let urlUpdateProfileData = "http://pretest-qa.dcidev.id/api/v1/profile"
private let urlUpdateProfileEducationData = "http://pretest-qa.dcidev.id/api/v1/profile/education"
private let urlUpdateProfileCareerData = "http://pretest-qa.dcidev.id/api/v1/profile/career"
private let urlSignOut = "http://pretest-qa.dcidev.id/api/v1/oauth/revoke"

class ApiService {
  
    static let shared: (NetworkService) -> ApiService = { service in
        return ApiService(networkService: service)
    }
  
    let networkService: NetworkService
  
    private init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    //<<<<<<<<<<REGISTER>>>>>>>>>>
    func register(params: [String: Any],
                  completion: @escaping (Result<User, NError>) -> Void) {
    
        networkService.request(of: RegisterResponse.self,
                               with: urlRegister,
                               withMethod: .post,
                               withHeaders: [:],
                               withParameter: params,
                               withEncoding: JSONEncoding.default) { result in
      
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let model):
                completion(.success(model.data.user))
            }
        }
    }
    
    //<<<<<<<<<<REQUEST OTP>>>>>>>>>>
    func requestOtp(params: [String: Any],
                    completion: @escaping (Result<Bool, NError>) -> Void) {
        
        networkService.postRequest(with: urlRequestOtp,
                                   withHeaders: [:],
                                   withParameter: params) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(_):
                completion(.success(true))
            }
        }
    }
    
    //<<<<<<<<<<MATCHING OTP>>>>>>>>>>
    func matchingOtp(params: [String: Any],
                     completion: @escaping (Result<UserToken, NError>) -> Void) {
      
        networkService.request(of: OtpResponse.self,
                               with: urlOtpMatch,
                               withMethod: .post,
                                withHeaders: [:],
                               withParameter: params,
                               withEncoding: JSONEncoding.default) { result in
        
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let model):
                completion(.success(model.data.user))
            }
        }
    }
    
    //<<<<<<<<<<SIGN IN METHOD>>>>>>>>>>
    func userSignIn(params: [String: Any],
                     completion: @escaping (Result<UserToken, NError>) -> Void) {
      
        networkService.request(of: OtpResponse.self,
                               with: urlSignIn,
                               withMethod: .post,
                                withHeaders: [:],
                               withParameter: params,
                               withEncoding: JSONEncoding.default) { result in
        
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let model):
                completion(.success(model.data.user))
            }
        }
    }
    
    //<<<<<<<<<<GET CREDENTIALS>>>>>>>>>>
    func getCredentials(params: [String: Any], accessToken: String,
                  completion: @escaping (Result<UserData, NError>) -> Void) {
    
        networkService.request(of: CredentialsResponse.self,
                               with: "\(baseUrlCredentials)\(accessToken)",
                               withMethod: .get,
                               withHeaders: [:],
                               withParameter: params,
                               withEncoding: URLEncoding.default) { result in
            print("\(baseUrlCredentials)\(accessToken)")
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let model):
                completion(.success(model.data.user))
            }
        }
    }
    
    //<<<<<<<<<<SIGN OUT>>>>>>>>>>
    func userSignOut(params: [String: Any],
                    completion: @escaping (Result<Bool, NError>) -> Void) {
        
        networkService.postRequest(with: urlSignOut,
                                   withHeaders: [:],
                                   withParameter: params) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(_):
                completion(.success(true))
            }
        }
    }
    
    //<<<<<<<<<<GET PROFILE DATA>>>>>>>>>>
    func getProfileData(params: [String: Any], accessToken: String,
                  completion: @escaping (Result<UserData, NError>) -> Void) {
    
        networkService.request(of: CredentialsResponse.self,
                               with: urlProfileData,
                               withMethod: .get,
                               withHeaders: ["Authorization":accessToken],
                               withParameter: params,
                               withEncoding: URLEncoding.default) { result in
      
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let model):
                completion(.success(model.data.user))
            }
        }
    }
    
    //<<<<<<<<<<UPDATE PROFILE DATA>>>>>>>>>>
    func updateProfileData(params: [String: Any], accessToken: String,
                    completion: @escaping (Result<Bool, NError>) -> Void) {
        
        networkService.postRequest(with: urlUpdateProfileData,
                                   withHeaders: ["Authorization":accessToken],
                                   withParameter: params) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(_):
                completion(.success(true))
            }
        }
    }
    
    //<<<<<<<<<<UPDATE EDUCATION DATA>>>>>>>>>>
    func updateEducationData(params: [String: Any], accessToken: String,
                    completion: @escaping (Result<Bool, NError>) -> Void) {
        
        networkService.postRequest(with: urlUpdateProfileEducationData,
                                   withHeaders: ["Authorization":accessToken],
                                   withParameter: params) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(_):
                completion(.success(true))
            }
        }
    }
    
    //<<<<<<<<<<UPDATE CAREER DATA>>>>>>>>>>
    func updateCareerData(params: [String: Any], accessToken: String,
                    completion: @escaping (Result<Bool, NError>) -> Void) {
        
        networkService.postRequest(with: urlUpdateProfileCareerData,
                                   withHeaders: ["Authorization":accessToken],
                                   withParameter: params) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(_):
                completion(.success(true))
            }
        }
    }
    
    
    
}
