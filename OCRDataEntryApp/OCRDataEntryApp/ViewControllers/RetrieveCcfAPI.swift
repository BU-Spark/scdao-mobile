//
//  RetrieveCcfAPI.swift
//  OCRDataEntryApp
//
//  Created by Justin Janice on 4/11/21.
//  Copyright © 2021 SparkBU. All rights reserved.
//

import Foundation
import UIKit


struct RetrieveCcfAPI {
    let baseURL: URL
    let token: String
    let type: String

    init(baseURL: String, token: String, type: String) {
        let resourceString = "http://\(baseURL)/api/"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.baseURL = resourceURL
        self.token = token
        self.type = type
    }
    
    func retrieveFiles() {
        let myUrl = baseURL.appendingPathComponent("v1/records/ccf")
        let request = NSMutableURLRequest(url:myUrl)
        
        request.httpMethod = "GET";
        
        let boundary = generateBoundaryString()
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")


        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if let responseData = data, let plainResponse = String(data: responseData, encoding: .utf8) {
                print("Response: " + plainResponse)
            }

                if error != nil {
                    print("error=\(error!)")
                    return
                }

                //print response
                //print("response = \(response!)")

                // print reponse body
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("response data = \(responseString!)")

            }

            task.resume()
        }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }




}
