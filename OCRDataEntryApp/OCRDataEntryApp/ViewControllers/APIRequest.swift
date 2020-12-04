//
//  APIRequest.swift
//  OCRDataEntryApp
//
//  Created by Neilkaran Rawal on 12/3/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//

import Foundation

enum APIError: Error {
    case HTTPValidationError
    case ValidationError
    
}

struct APIRequest {
    let resourceURL: URL
    
    init(endpoint: String) {
        let resourceString = "http://localhost:8000/api/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    
    
    func save (_ messageToSave:Message, completion: @escaping(Result<Message, APIError>) -> Void)  {
    
    do{
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(messageToSave)
    
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let
                jsonData = data else {
                completion(.failure(.HTTPValidationError))
                return
    }
            do {
                let messageData = try JSONDecoder().decode(Message.self, from: jsonData)
                completion(.success(messageData))
            } catch {
                completion(.failure(.HTTPValidationError))
            }
}
        dataTask.resume()
    } catch{
        completion(.failure(.ValidationError))
    }
}
    
}
