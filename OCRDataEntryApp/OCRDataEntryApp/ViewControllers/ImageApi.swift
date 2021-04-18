//
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
    
    func uploadImage(imageToUpload: UIImage) -> String{
        let myUrl = baseURL.appendingPathComponent("v1/uploads/ccf")
        let request = NSMutableURLRequest(url:myUrl)
        var uploadStatusMessage = ""
        
        request.httpMethod = "POST";
        
        let param: [String: String] = [:]
        let boundary = generateBoundaryString()
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")

        guard let imageData = imageToUpload.jpegData(compressionQuality: 1) else {
            uploadStatusMessage = "Error"
            return uploadStatusMessage
        }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if let responseData = data, let plainResponse = String(data: responseData, encoding: .utf8) {
                print("Response: " + plainResponse)
            }

            if error != nil {
                print("error=\(error!)")
                uploadStatusMessage = "Error"
            }

                //print response
                //print("response = \(response!)")

                // print reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response data = \(responseString!)")
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: [])
            if let responseString = json as? [String: Any], let job_id = responseString["job id"] as? String {
                print("JOB ID: ", job_id)
                
               // keep making apiCall until either a SUCCESS or FAIL (ignore or pass if error or task_state = STARTING)
               DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { //delay
                   uploadStatusMessage = uploadStatus(task_id: job_id)
               }
                    
            }
        }

        task.resume()
        return uploadStatusMessage
    }
    
    func uploadStatus (task_id: String) -> String {
        let myUrl = baseURL.appendingPathComponent("v1/tasks/\(task_id)") //add task
        let request = NSMutableURLRequest(url:myUrl)
        var statusMessage = "Uploading"
        
        request.httpMethod = "GET";
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            if let responseData = data, let plainResponse = String(data: responseData, encoding: .utf8) {
                print("Response: " + plainResponse)
            }

            if error != nil {
                print("error=\(error!)")
                statusMessage = "Error"
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response data = \(responseString!)")
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: [])
            if let responseString = json as? [String: Any], let status = responseString["task_state"] as? String{
                print("TASK STATE: ", status)
                statusMessage = status
            }

        }
        task.resume()
        return statusMessage
        
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

    }

//struct StatusAPI {
//    let baseURL: URL
//    
//    func uploadStatus (task_id: String) {
//        let myUrl = baseURL.appendingPathComponent("v1/tasks/\(task_id)") //add task
//        print("myURL:", myUrl)
//        
//        let request = NSMutableURLRequest(url:myUrl)
//
//        request.httpMethod = "GET";
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            data, response, error in
//
//            if let responseData = data, let plainResponse = String(data: responseData, encoding: .utf8) {
//                print("Response: " + plainResponse)
//            }
//
//            if error != nil {
//                print("error=\(error!)")
//                return
//            }
//
//                //print response
//                //print("response = \(response!)")
//
//                // print reponse body
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print("response data = \(responseString!)")
//
//        }
//        
//        task.resume()
//    }
//}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
