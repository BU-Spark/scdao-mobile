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

class ImageAPI {
    let baseURL: URL
    let token: String
    let type: String
    var timer: Timer?
    var uploadStatus: String

    init(baseURL: String, token: String, type: String) {
        let resourceString = "http://\(baseURL)/api/"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.baseURL = resourceURL
        self.token = token
        self.type = type
        self.uploadStatus = ""
    }
    
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
//            uploadStatusMessage = "Error"
            return completion(nil)
        }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)

        URLSession.shared.dataTask(with: request as URLRequest) { [self]
            data, response, error in
            
            if let data = data{
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                if let responseString = json as? [String: Any], let job_id = responseString["job id"] as? String {
                    print("here")
                    DispatchQueue.main.async {
                        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(statusHandler(sender:)), userInfo: (job_id), repeats: true)
                    }
                    return completion(uploadStatus)
                }
                return completion(nil)
            }
            else{
                return completion(nil)
            }
        }.resume()
    }
    
    //                            while (uploadStatusMessage != "SUCCESS"){
    //                                print("here")
    //                                uploadStatus(task_id: job_id){ status in
    //                                    print("STATUS: ", status)
    //                                    if let status = status{
    //                                        uploadStatusMessage = status
    //                                        print("uploadStatusMessage: ", uploadStatusMessage)
    //                                    }
    //                                }
    //                            }
    //                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { //delay
    //                                    uploadStatus(task_id: job_id){ status in
    //                                        if let status = status{
    //                                            uploadStatusMessage = status
    //                                            print("uploadStatusMessage: ", uploadStatusMessage)
    //                                        }
    //                                }
    //                            }
    
    
    //            if error != nil {
    //                print("error=\(error!)")
    //                uploadStatusMessage = error?.localizedDescription ?? "Error"
    //            }
    //
    //            let json = try! JSONSerialization.jsonObject(with: data!, options: [])
    //            if let responseString = json as? [String: Any], let job_id = responseString["job id"] as? String
    //            {
    //                print("JOB ID: ", job_id)
    //
    //               // keep making apiCall until either a SUCCESS or FAIL (ignore or pass if error or task_state = STARTING)
    //               DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { //delay
    //                uploadStatus(task_id: job_id){ status in
    //                    print("uploadStatusMessage: ", uploadStatusMessage)
    //                }
    //               }
    //            }
    
    @objc func uploadStatus (task_id: String, completion: @escaping (String?)->()){
        let myUrl = baseURL.appendingPathComponent("v1/tasks/\(task_id)") //add task id
        let request = NSMutableURLRequest(url:myUrl)
        
        request.httpMethod = "GET";
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let data = data{
                print(data)
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                if let responseString = json as? [String: Any], let status = responseString["task_state"] as? String{
                    print("TASK STATE: ", status)
                    print("status: ", status)
                    return completion(status)
                }
                return completion(nil)
            }
            else{
                return completion(nil)
            }
        }.resume()
    }

//    @objc func statusHandler(timer:Timer) {
//        let taskID = timer.userInfo as! String
//        print("Helper taskID: ", taskID)
//
////        self.uploadStatus(id: job_id){ status in
////            if let status = status{
////                print("Intermediate Function: ", status)
////            }
////        }
////
////        fetchDatabase(completion: { (result) in
////            // Stuff in here
////        })
//    }
    
//    @objc func updateCounter() {
//        //example functionality
//        if counter > 0 {
//            print("\(counter) seconds")
//            counter -= 1
//        }
//    }
    
//    @objc func iGotCall(sender: Timer) {
//        print((sender.userInfo)!)
//    }

        @objc func statusHandler(sender: Timer) {
            print((sender.userInfo)!)
            let jobID = sender.userInfo
            uploadStatus(task_id: jobID as! String){ status in
                print("STATUS: ", status!)
                if let status = status{
                    if (status == "SUCCESS"){
                        print("Timer: ", status)
                        self.uploadStatus = status
                        self.timer?.invalidate()
                    }
                    if (status == "AWS_FAIL" || status == "OCR_FAIL"){
                        print("Timer: ", status)
                        self.uploadStatus = status
                        self.timer?.invalidate()
                    }
                    else{
                        print("Timer: ", status)
                    }
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

    }

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
