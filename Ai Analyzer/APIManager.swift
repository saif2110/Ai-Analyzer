//
//  APIManager.swift
//  Motivation_Demo
//
//  Created by Admin on 19/09/23.
//

import Foundation



class APIRequest {
    
    func callAPI<T: Codable>(URLstring:String ,model:T.Type,parameters:[String:String] = [:],completion: @escaping (Bool, T?) -> ()){
        
        var retries = 3
        
        
        var request = URLRequest(url: URL(string: URLstring)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(false, nil)
        }
        
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        let session = URLSession(configuration: sessionConfig)
     
        func fetchData(withRetries retries: Int) {
              let task = session.dataTask(with: request) { data, response, error in
                  if let data = data {
                      do {
                          if let jsonString = String(data: data, encoding: .utf8) {
                                         print("Raw JSON data: \(jsonString)")
                                     }
                          let jsonDecoder = JSONDecoder()
                          let userData = try! jsonDecoder.decode(model, from: data)
                          DispatchQueue.main.async {
                              completion(true, userData)
                          }
                      } catch {
                          // Retry logic: Retry up to 'retries' times if there's a decoding error
                          if retries > 0 {
                              print("Retrying... Due to decoding error - attempts left - \(retries)")
                              fetchData(withRetries: retries - 1)
                          } else {
                              DispatchQueue.main.async {
                                  completion(false, nil)
                              }
                          }
                      }
                  } else {
                      // Retry logic: Retry up to 'retries' times if there's a network error
                      if retries > 0 {
                          print("Retrying... Due to network error - attempts left - \(retries)")
                          fetchData(withRetries: retries - 1)
                      } else {
                          DispatchQueue.main.async {
                              completion(false, nil)
                          }
                      }
                  }
              }
              task.resume()
          }
        
        fetchData(withRetries: retries)
    }
    
    
}


struct APIFAILED {
    static var shared = APIFAILED()
    let APIERRORCODE1 = "NO_DATA_FOUND"
    let APIERRORCODE2 = "APIFAILED_PARSING"
}
