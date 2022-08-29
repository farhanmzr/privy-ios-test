//
//  ApiSetup.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 24/06/22.
//

import Foundation
import Alamofire

class ApiSetup {
    
    static let shared: ApiSetup = ApiSetup()
    private init() { }
    
    func get(url: String, parameter: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
      AF.request(
        url,
        method: .get,
        parameters: parameter,
        encoding: URLEncoding.default
      ).responseData { response in
        switch response.result {
        case .success(let data):
          completion(.success(data))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
    
    func post(url: String, parameter: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
      AF.request(
        url,
        method: .post,
        parameters: parameter,
        encoding: JSONEncoding.default
      ).responseData { response in
        switch response.result {
        case .success(let data):
          completion(.success(data))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
    
}
