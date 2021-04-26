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
    
    var activityIndicator = UIActivityIndicatorView()

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
            return completion(nil)
        }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)

        URLSession.shared.dataTask(with: request as URLRequest) { [self]
            data, response, error in
            guard let serverResponse = response as? HTTPURLResponse, (200...299).contains(serverResponse.statusCode)  else {
                serverErrorHandler(response: response as! HTTPURLResponse)
                return completion(nil)
            }
            if error != nil || data == nil {
                print(error.debugDescription)
                return
            }
            if let data = data{
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                if let responseString = json as? [String: Any], let job_id = responseString["job id"] as? String {
                    print("here")
                    
                    DispatchQueue.main.async{
                        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(statusHandler(sender:)), userInfo: (job_id), repeats: true)
                    }
                    return completion("VALUE")
                }
                return completion(nil)
            }
            else{
                return completion(nil)
            }
        }.resume()
    }

    
    @objc func uploadStatus (task_id: String, completion: @escaping (String?)->()){
        let myUrl = baseURL.appendingPathComponent("v1/tasks/\(task_id)") //add task id
        let request = NSMutableURLRequest(url:myUrl)
        
        request.httpMethod = "GET";
        request.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
//            print("E", error.debugDescription)
//            print("R", response)
//            print("D", data)
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

        @objc func statusHandler(sender: Timer) {
            print((sender.userInfo)!)
            let jobID = sender.userInfo
            let pending = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

            uploadStatus(task_id: jobID as! String){ status in
                print("STATUS: ", status!)
                if let status = status{
                    if (status == "SUCCESS"){
                        self.timer?.invalidate()
                        self.timer = nil
                        print("Timer: ", status)
                        
                        self.uploadStatus = status
                        
                        print("Alert Value: ", status)
                   
                        DispatchQueue.main.async {
                            getTopMostViewController()?.dismiss(animated: false, completion: nil)
                            showAlert(field: "Upload Successful", info: "Document uploaded successfully.")
                        }
                        
                    }
                    if (status == "AWS_FAIL" || status == "OCR_FAIL"){
                        self.timer?.invalidate()
                        self.timer = nil
                        print("Timer: ", status)
                        self.uploadStatus = status
                        
                        print("Alert Value: ", status)
                        
                        DispatchQueue.main.async {
  
                            pending.dismiss(animated: false, completion: nil)
                                
                            showAlert(field: "Upload Failed", info: "Document upload failed. Please try again.")
                        }
            
                    }
                    if (status == "STARTING"){
                        print("VALID")
                        
                        DispatchQueue.main.async {
                            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                            loadingIndicator.hidesWhenStopped = true
                            loadingIndicator.style = UIActivityIndicatorView.Style.medium
                            loadingIndicator.startAnimating();
                            
                            pending.view.addSubview(loadingIndicator)
                            getTopMostViewController()?.present(pending, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    
   @objc func serverErrorHandler(response: HTTPURLResponse){
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

////Based off of: https://www.javaer101.com/en/article/11613040.html
func getTopMostViewController() -> UIViewController? {
    var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

    while let presentedViewController = topMostViewController?.presentedViewController {
        topMostViewController = presentedViewController
    }

    return topMostViewController
}

//extension UIApplication {
//  class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//    if let tabController = controller as? UITabBarController {
//      return topViewController(controller: tabController.selectedViewController)
//    }
//    if let navController = controller as? UINavigationController {
//      return topViewController(controller: navController.visibleViewController)
//    }
//    if let presented = controller?.presentedViewController {
//      return topViewController(controller: presented)
//    }
//    return controller
//  }
//}

func showAlert(field: String, info: String) {
    let alert = UIAlertController(title: field, message: info, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    getTopMostViewController()?.present(alert, animated: false, completion: nil) 
}


//func showPendingAlert(sender: UIViewController){
//    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//    loadingIndicator.hidesWhenStopped = true
//    loadingIndicator.style = UIActivityIndicatorView.Style.medium
//    loadingIndicator.startAnimating();
//
//    alert.view.addSubview(loadingIndicator)
//    getTopMostViewController()!.present(alert, animated: true, completion: nil)
//}

func dismissAlert(alert: UIAlertController) {
    alert.dismiss(animated: true, completion: nil)
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

////Based off of: https://gist.github.com/db0company/369bfa43cb84b145dfd8
//extension UIViewController {
//    func topMostViewController() -> UIViewController {
//        if self.presentedViewController == nil {
//            return self
//        }
//        if let navigation = self.presentedViewController as? UINavigationController {
//            return (navigation.visibleViewController?.topMostViewController())!
//        }
//        if let tab = self.presentedViewController as? UITabBarController {
//            if let selectedTab = tab.selectedViewController {
//                return selectedTab.topMostViewController()
//            }
//            return tab.topMostViewController()
//        }
//        return self.presentedViewController!.topMostViewController()
//    }
//}

//extension UIApplication {
//  func topMostViewController() -> UIViewController? {
//    return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.topMostViewController()
//  }
//}

