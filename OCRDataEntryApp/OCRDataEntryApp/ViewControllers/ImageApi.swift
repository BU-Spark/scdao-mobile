//  ImageApi.swift
//  OCRDataEntryApp
//  Code borrowed from https://stackoverflow.com/questions/37474265/swift-2-how-do-you-add-authorization-header-to-post-request 
//  and https://stackoverflow.com/questions/26335656/how-to-upload-images-to-a-server-in-ios-with-swift
//
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

class ImageAPI {
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
    
    // uploads image and gets back job_id
    func uploadImage(imageToUpload: UIImage, completion: @escaping (String?)->()){
        let myUrl = baseURL.appendingPathComponent("v1/uploads/ccf")
        let request = NSMutableURLRequest(url:myUrl)
        
        request.httpMethod = "POST";
        
        let param: [String: String] = [:]
        let boundary = generateBoundaryString()
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")
        
        guard let imageData = imageToUpload.jpegData(compressionQuality: 1) else {
            return completion(nil)
        }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        
        URLSession.shared.dataTask(with: request as URLRequest) { [self]
            data, response, error in
            if response == nil{
                return completion("Not connected to API")
            }
            if let serverResponse = response as? HTTPURLResponse, !(200...299).contains(serverResponse.statusCode) {
                return(completion(serverErrorHandler(response: response as! HTTPURLResponse))) // handle status codes with errors
            }
            if error != nil || data == nil {
                print("Error ", error?.localizedDescription ?? "")
                return completion(nil)
            }
            if let data = data{
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                if let responseString = json as? [String: Any], let job_id = responseString["job id"] as? String {
                    return completion(job_id)
                }
                return completion(nil)
            }
            else{
                return completion(nil)
            }
        }.resume()
    }
    
    // retrieves upload status (SUCCESS, AWS_FAIL, OCR_FAIL, STARTING)
    @objc func uploadStatus (task_id: String, completion: @escaping (String?)->()){
        let myUrl = baseURL.appendingPathComponent("v1/tasks/\(task_id)")
        let request = NSMutableURLRequest(url:myUrl)
        
        request.httpMethod = "GET";
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if response == nil{
                print("Error: Not connected to backend")
                return completion(nil)
            }
            if let serverResponse = response as? HTTPURLResponse, !(200...299).contains(serverResponse.statusCode) {
                print("Error Code: ", (completion(self.serverErrorHandler(response: response as! HTTPURLResponse))))
                return completion(nil)
            }
            if error != nil || data == nil {
                print("Error ", error?.localizedDescription ?? "")
                return completion(nil)
            }
            if let data = data{
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                if let responseString = json as? [String: Any], let status = responseString["task_state"] as? String{
                    print("TASK STATE: ", status)
                    return completion(status)
                }
                return completion(nil)
            }
            else{
                return completion(nil)
            }
        }.resume()
    }
    
    // returns API response codes for specific errors
    @objc private func serverErrorHandler(response: HTTPURLResponse) -> String{
        let statusCode = response.statusCode
        switch statusCode{
        case 400:
            return "Invalid Params"
            
        case 403:
            return "Unauthorized Access"
            
        default:
            return "Server Error"
        }
    }
}


func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
    let body = NSMutableData();
    
    let mimetype = "image/jpeg"
    
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

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
