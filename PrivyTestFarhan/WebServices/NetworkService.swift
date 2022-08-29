//
//  NetworkService.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 24/06/22.
//

import Foundation
import Alamofire

public protocol NetworkService {
  func request<T: Codable>(of type: T.Type,
                           with url: String,
                           withMethod method: HTTPMethod?,
                           withHeaders headers: HTTPHeaders,
                           withParameter parameters: Parameters,
                           withEncoding encoding: ParameterEncoding?,
                           completion: @escaping(Result<T, NError>) -> Void)
  
  func getRequest(with url: String,
                  withHeaders headers: HTTPHeaders,
                  withParameter parameters: Parameters,
                  completion: @escaping(Result<Bool, NError>) -> Void)
    
  
  func postRequest(with url: String,
                   withHeaders headers: HTTPHeaders,
                   withParameter parameters: Parameters,
                   completion: @escaping(Result<Bool, NError>) -> Void)
  
  func handleStatusCode(statusCode: Int,
                                data: Data?,
                                success: @escaping ((Data) -> Void),
                                failure: @escaping ((NError) -> Void))
}

public protocol LocalService {
  func parsingJSON<T>(of type: T.Type, from data: Data) -> Result<T, NError> where T: Codable
  func loadJsonFromFile(with url: String) -> Data
}
