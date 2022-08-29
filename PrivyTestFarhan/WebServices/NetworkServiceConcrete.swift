//
//  NetworkServiceConcrete.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 25/06/22.
//

import Foundation
import Alamofire

public class NetworkServiceConcrete: NetworkService {
    
  public init() {}
  
  public func request<T: Codable>(of type: T.Type,
                                  with url: String,
                                  withMethod method: HTTPMethod? = .get,
                                  withHeaders headers: HTTPHeaders = [:],
                                  withParameter parameters: Parameters = [:],
                                  withEncoding encoding: ParameterEncoding? = URLEncoding.default,
                                  completion: @escaping(Result<T, NError>) -> Void) {
    
    AF.request(
      url,
      method: method ?? .get,
      parameters: parameters,
      encoding: encoding ?? URLEncoding.default,
      headers: headers
    ).responseString(queue: DispatchQueue.main,
                     encoding: String.Encoding.utf8,
                     completionHandler: { (response) in
      
      let log = Logging(
        url: response.request?.url,
        header: response.request?.headers.dictionary ?? [:],
        param: response.request?.httpBody ?? Data(),
        statusCode: response.response?.statusCode ?? -1,
        response: response.data ?? Data()
      )
      
      log.show()
      
      if let error = response.error {
        if error.responseCode == -1009 {
          completion(.failure(.connectionProblem))
        }else {
          completion(.failure(.undefinedError))
        }
        return
      }
      
      guard let statusCode = response.response?.statusCode else {
        completion(.failure(.undefinedError))
        return
      }
      
      self.handleStatusCode(statusCode: statusCode, data: response.data) { data in
        //parsing json
        do {
          let json = try JSONDecoder().decode(T.self, from: data)
          completion(.success(json))
          
        } catch {
          completion(.failure(.parseError))
          print("parse_error", error)
        }
      } failure: { nerror in
        completion(.failure(nerror))
      }
      
    })
    
  }
  
  public func getRequest(with url: String,
                         withHeaders headers: HTTPHeaders,
                         withParameter parameters: Parameters,
                         completion: @escaping(Result<Bool, NError>) -> Void) {
    
    AF.request(
      url,
      method: .get,
      parameters: parameters,
      encoding: URLEncoding.default,
      headers: headers
    ).responseString(queue: DispatchQueue.main,
                     encoding: String.Encoding.utf8,
                     completionHandler: { (response) in
      
      let log = Logging(
        url: response.request?.url,
        header: response.request?.headers.dictionary ?? [:],
        param: response.request?.httpBody ?? Data(),
        statusCode: response.response?.statusCode ?? -1,
        response: response.data ?? Data()
      )
      
      log.show()
      
      if let error = response.error {
        if error.responseCode == -1009 {
          completion(.failure(.connectionProblem))
        }else {
          completion(.failure(.undefinedError))
        }
        return
      }
      
      guard let statusCode = response.response?.statusCode else {
        completion(.failure(.undefinedError))
        return
      }
      
      self.handleStatusCode(statusCode: statusCode, data: response.data) { data in
        completion(.success(true))
      } failure: { nerror in
        completion(.failure(nerror))
      }
      
    })
    
  }
  
  public func postRequest(with url: String,
                          withHeaders headers: HTTPHeaders,
                          withParameter parameters: Parameters,
                          completion: @escaping(Result<Bool, NError>) -> Void) {
    
    AF.request(
      url,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: headers
    ).responseString(queue: DispatchQueue.main,
                     encoding: String.Encoding.utf8,
                     completionHandler: { (response) in
      
      //Log
      let log = Logging(
        url: response.request?.url,
        header: response.request?.headers.dictionary ?? [:],
        param: response.request?.httpBody ?? Data(),
        statusCode: response.response?.statusCode ?? -1,
        response: response.data ?? Data()
      )
      
      log.show()
      
      if let error = response.error {
        if error.responseCode == -1009 {
          completion(.failure(.connectionProblem))
        }else {
          completion(.failure(.undefinedError))
        }
        return
      }
      
      guard let statusCode = response.response?.statusCode else {
        completion(.failure(.undefinedError))
        return
      }
      
      self.handleStatusCode(statusCode: statusCode, data: response.data) { data in
        completion(.success(true))
      } failure: { nerror in
        completion(.failure(nerror))
      }
      
    })
    
  }
  
  public func handleStatusCode(statusCode: Int,
                               data: Data?,
                               success: @escaping ((Data) -> Void),
                               failure: @escaping ((NError) -> Void)){
    if 200 ... 299 ~= statusCode  {
      //success
      guard let data = data else {
        failure(.undefinedError)
        return
      }
      
      success(data)
      
    } else if statusCode == 400 {
      guard let data = data else { return }
      parseEror(data) { error in
        failure(error)
      }
    } else if statusCode == 401 {
      failure(.unauthorized)
      
    } else if 402..<499 ~= statusCode {
      guard let data = data else { return }
      parseEror(data) { error in
        failure(error)
      }
    } else if statusCode == 500 {
      //internal server error
      failure(.internalServerError)
      
    } else {
      // throw unknown error
      failure(.undefinedError)
    }
  }
  
  fileprivate func parseEror(_ data: Data, completion: @escaping(NError) -> Void){
    do {
      let errorResult = try JSONDecoder().decode(ErrorResponse.self, from: data)
      completion(.responseError(message: errorResult.message ?? ""))
      return
    } catch let decodingError {
      print("Error decoding!", decodingError)
      completion(.parseError)
      return
    }
  }
  
}

public struct Logging {
  
  let url: URL?
  let header: [String: String]
  let param: Data
  let statusCode: Int
  let response: Data
  
  func show() {
    print("url", String(describing: url))
    print("header", String(describing: header))
    print("params", String(data: param, encoding: .utf8)!)
    print("statuscode", String(describing: statusCode))
    
    let jsonStr = String(data: response, encoding: .utf8)!
    let pretty = jsonStr.replacingOccurrences(of: "\\", with: "")
    
    print("response", pretty)
  }
  
}
