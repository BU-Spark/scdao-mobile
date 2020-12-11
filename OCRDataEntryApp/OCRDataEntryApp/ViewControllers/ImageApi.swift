//
//  ImageApi.swift
//  OCRDataEntryApp
//
//  Created by Eesha Gholap on 12/4/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//  reference :https://www.donnywals.com/uploading-images-and-forms-to-a-server-using-urlsession/ 

import Foundation
import UIKit

enum ImageError: Error {
    case HTTPValidationError
    case ValidationError
}

struct ImageAPI {
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
    
    func uploadImage(imageToUpload: UIImage) {
        let myUrl = baseURL.appendingPathComponent("v1/uploads/ccf")
        let request = NSMutableURLRequest(url:myUrl)
        
        request.httpMethod = "POST";
        
        let param: [String: String] = [:]
        let boundary = generateBoundaryString()
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")

        guard let imageData = imageToUpload.jpegData(compressionQuality: 1) else {
            return
        }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)

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
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
            let body = NSMutableData();

        /*
            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }*/

            let mimetype = "image/jpg"

            body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; file=\"\(filePathKey!).jpg\"; filename=\"file\"; name=\"file\"; type=\"\(mimetype)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)--\r\n")

            return body as Data
        }

        func generateBoundaryString() -> String {
            return "Boundary-\(NSUUID().uuidString)"
        }

    }

    extension NSMutableData {
        func appendString(string: String) {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            append(data!)
        }
    }
