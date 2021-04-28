//
//  AuthAPI.swift
//  OCRDataEntryApp
//
//  Created by WAIL ATTAUABI on 12/3/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//  references for escape func
//              https://github.com/Alamofire/Alamofire/blob/master/Source/URLEncodedFormEncoder.swift
//              https://stackoverflow.com/questions/24551816/swift-encode-url

import Foundation

enum AUTHError: Error {
    case HTTPValidationError
    case ValidationError
    case ResponseError
}

struct LoginResponse: Codable {
    let token: String
    let type : String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case type = "token_type"
    }
}

struct AuthAPI {
    let baseURL: URL
    
    init(baseURL: String) {
        let resourceString = "http://\(baseURL)/api/"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.baseURL = resourceURL
    }
    
    
    func signup(user: String, pass: String, completion handler: @escaping(Bool, AUTHError?, String) -> Void) {
        let data = ["username": user.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "password": pass.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "grant_type": "", "scope": "", "client_id": "", "client_secret": ""]
        
        responseString(endpoint: "signup", data: data, completion: { (data, error, response) in
            handler(data != nil, error, response)
        })
        
    }
    
    func signin(user: String, pass: String, completion handler: @escaping(LoginResponse?, AUTHError?, String) -> Void) {
        let data = ["username": escape(user),
                    "password": pass.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "grant_type": "", "scope": "", "client_id": "", "client_secret": ""]
        
        responseString(endpoint: "token", data: data, completion: { (data, error, apiResponse) in
            if let error = error {
                handler(nil, error, apiResponse)
                return
            }
            
            guard let data = data else {
                handler(nil, error, apiResponse)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let respose = try decoder.decode(LoginResponse.self, from: data)
                
                handler(respose, nil, apiResponse)
            } catch {
                handler(nil, .ResponseError, apiResponse)
            }
        })
    }
    private func escape(_ string: String) -> String {
        let escapingCharacters = ":#[]@!$&'()*+,;="

        guard let allowedCharacters = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as? NSMutableCharacterSet else {
            return string
        }
        
        allowedCharacters.removeCharacters(in: escapingCharacters)
            
        return string.addingPercentEncoding(
            withAllowedCharacters: allowedCharacters as CharacterSet)!
    }
    
    private func responseString(endpoint: String, data: [String: String], completion: @escaping(Data?, AUTHError?, String) -> Void) {
        let fullURL = baseURL.appendingPathComponent(endpoint)
        
        var urlRequest = URLRequest(url: fullURL)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let body = data.map { $0 + "=" + $1 }.joined(separator: "&")
            let bodyData = body.data(using: .utf8, allowLossyConversion: false)
            
            urlRequest.httpBody = bodyData
            
            //helps with debugging request responses by printing in console
//            print("Request: " + fullURL.absoluteString)
//            print("Body: " + body)
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if data == nil {
                    completion(nil, .HTTPValidationError, "Backend not running")
                    return
                }
                let plainResponse = String(data: (data)!, encoding: .utf8)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(nil, .HTTPValidationError, plainResponse!)
                    return
                }
                
                completion(data, nil, plainResponse!)
            }
    
            .resume()
        } catch {
            completion(nil, .ValidationError, "" )
        }
    }
}
