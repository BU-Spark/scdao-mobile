//
//  AuthAPI.swift
//  OCRDataEntryApp
//
//  Created by WAIL ATTAUABI on 12/3/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//

import Foundation

enum AUTHError: Error {
    case HTTPValidationError
    case ValidationError
}

struct AuthAPI {
    let baseURL: URL
    
    init(baseURL: String) {
        let resourceString = "http://\(baseURL)/api/"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.baseURL = resourceURL
    }
    
    func signup(user: String, pass: String, completion handler: @escaping(Bool, AUTHError?) -> Void) {
        let data = ["username": user.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "password": pass.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "grant_type": "", "scope": "", "client_id": "", "client_secret": ""]
        
        perform(endpoint: "signup", data: data, completion: handler)
    }
    
    func signin(user: String, pass: String, completion handler: @escaping(Bool, AUTHError?) -> Void) {
        let data = ["username": user.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "password": pass.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "grant_type": "", "scope": "", "client_id": "", "client_secret": ""]
        
        perform(endpoint: "token", data: data, completion: handler)
    }
    
    private func perform(endpoint: String, data: [String: String], completion: @escaping(Bool, AUTHError?) -> Void) {
        let fullURL = baseURL.appendingPathComponent(endpoint)
        
        var urlRequest = URLRequest(url: fullURL)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            // "username=111&password=3333"
            
            let body = data.map { $0 + "=" + $1 }.joined(separator: "&")
            let bodyData = body.data(using: .utf8, allowLossyConversion: false)
            
            urlRequest.httpBody = bodyData
            
            print("Request: " + fullURL.absoluteString)
            print("Body: " + body)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let responseData = data, let plainResponse = String(data: responseData, encoding: .utf8) {
                    print("Response: " + plainResponse)
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(false, .HTTPValidationError)
                    return
                }
                
                completion(true, nil)
            }
            
            dataTask.resume()
        } catch {
            completion(false, .ValidationError)
        }
    }
}
