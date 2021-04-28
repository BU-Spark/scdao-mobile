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
    private var timer: Timer?
    private var statusCheckedFirst = false
    
    init(baseURL: String, token: String, type: String) {
        let resourceString = "http://\(baseURL)/api/"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.baseURL = resourceURL
        self.token = token
        self.type = type
    }
    
    // uploads image
    func uploadImage(imageToUpload: UIImage, completion: @escaping (Bool?)->()){
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
            guard let serverResponse = response as? HTTPURLResponse, (200...299).contains(serverResponse.statusCode)  else {
                serverErrorHandler(response: response as! HTTPURLResponse) // handle status codes with errors
                return completion(nil)
            }
            if error != nil || data == nil {
                print(error.debugDescription)
                print("Not connected to backend")
                return completion(nil)
            }
            if let data = data{
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                if let responseString = json as? [String: Any], let job_id = responseString["job id"] as? String {
                    DispatchQueue.main.async{
                        //timer calls statusHandler() function repeatedly until task state returns a Success or Fail
                        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(statusHandler(sender:)), userInfo: (job_id), repeats: true)
                    }
                    return completion(true)
                }
                return completion(nil)
            }
            else{
                return completion(nil)
            }
        }.resume()
    }
    
    // retrieves upload status (SUCCESS, AWS_FAIL, OCR_FAIL, STARTING)
    @objc private func uploadStatus (task_id: String, completion: @escaping (String?)->()){
        let myUrl = baseURL.appendingPathComponent("v1/tasks/\(task_id)") //add task id
        let request = NSMutableURLRequest(url:myUrl)
        
        request.httpMethod = "GET";
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
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
    
    // called by timer to fetch upload status until SUCCESS or FAIL (timer invalidates upon SUCCESS or FAIL)
    @objc private func statusHandler(sender: Timer) {
        let jobID = sender.userInfo
        
        if (statusCheckedFirst == true){ //if loading alert already displayed
            DispatchQueue.main.async {
                getTopMostViewController()?.dismiss(animated: false, completion: nil) //remove loading alert
            }
        }
        statusCheckedFirst = true
        
        uploadStatus(task_id: jobID as! String){ status in // get status using job_id
            print("STATUS: ", status!)
            if let status = status{
                if (status == "SUCCESS"){
                    self.statusCheckedFirst = false
                    self.timer?.invalidate()
                    self.timer = nil
                    DispatchQueue.main.async {
                        showAlert(field: "Upload Successful", info: "Document uploaded successfully.")
                    }
                }
                if (status == "AWS_FAIL" || status == "OCR_FAIL"){
                    self.statusCheckedFirst = false
                    self.timer?.invalidate()
                    self.timer = nil
                    DispatchQueue.main.async {
                        showAlert(field: "Upload Failed", info: "Document upload failed. Please try again.")
                    }
                }
                if (status == "STARTING"){
                    DispatchQueue.main.async {
                        pendingAlert(info: "Uploading Image ...") //display loading alert
                    }
                }
            }
        }
    }
    
    @objc private func serverErrorHandler(response: HTTPURLResponse){
        let statusCode = response.statusCode
        switch statusCode{
        case 400:
            showAlert(field: "400 Error", info: "Please upload a document with the valid parameters")
            print("400: File param error")
            
        case 403:
            showAlert(field: "403 Forbidden", info: "User not authorized to upload documents.")
            print("403: Forbidden")
            
        default:
            showAlert(field: "Server Error", info: "Please try again.")
            print("Server Error")
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

//  Code borrowed from: https://www.javaer101.com/en/article/11613040.html (Published 10/19/2020)
func getTopMostViewController() -> UIViewController? {
    var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
    
    while let presentedViewController = topMostViewController?.presentedViewController {
        topMostViewController = presentedViewController
    }
    //    print("VC: ", topMostViewController)
    return topMostViewController
}

func showAlert(field: String, info: String) {
    let alert = UIAlertController(title: field, message: info, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    getTopMostViewController()?.present(alert, animated: false, completion: nil) 
}

//  Code borrowed from: https://stackoverflow.com/questions/27960556/loading-an-overlay-when-running-long-tasks-in-ios (Published 12/14/15 by user Ajinkya Patil)
func pendingAlert(info: String) {
    let pending = UIAlertController(title: nil, message: info, preferredStyle: .alert) //loading alert
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.medium
    loadingIndicator.startAnimating();
    
    pending.view.addSubview(loadingIndicator)
    getTopMostViewController()?.present(pending, animated: false, completion: nil)
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
