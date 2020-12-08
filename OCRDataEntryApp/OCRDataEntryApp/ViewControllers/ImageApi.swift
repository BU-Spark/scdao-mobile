//
//  ImageApi.swift
//  OCRDataEntryApp
//
//  Created by Eesha Gholap on 12/4/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//

import Foundation
import UIKit

enum ImageError: Error {
    case HTTPValidationError
    case ValidationError
}

struct ImageAPI {
    let baseURL: URL

    init(baseURL: String) {
        let resourceString = "http://\(baseURL)/api/"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.baseURL = resourceURL
    }
    
    func uploadImage(imageToUpload: UIImage) {

        let myUrl = NSURL(string: "http://localhost/api/v1/uploads/ccf");
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";

        let param = [
            "firstName"  : "name",
            "lastName"    : "name",
            "userId"    : "42"
        ]

        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = imageToUpload.jpegData(compressionQuality: 1)
        if imageData == nil  {
            return
        }

        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

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
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
            let body = NSMutableData();

            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }

            let mimetype = "image/jpg"

            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\("image")\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)--\r\n")

            return body
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
    
//    func uploadImage() {
//        let url = baseURL.appendingPathComponent("v1/uploads/ccf")
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let boundary = "Boundary-\(NSUUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        var retreivedImage: UIImage? = nil
//        //Get image
//        do {
//            // retrieve image here
//
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//            let readData = try Data(contentsOf: URL(string: "file://\(documentsPath)/myImage")!)
//            print("CHECK")
//            print(readData)
//            retreivedImage = UIImage(data: readData)
//            //retreivedImage = UIImagePickerController.InfoKey.originalImage as? UIImage
//            //retreivedImage = UIImage(image: retreivedImage)
//            //addProfilePicView.setImage(retreivedImage, for: .normal)
//        }
//        catch {
//            print("Error while opening image")
//            return
//        }
//
//        let imageData = retreivedImage!.jpegData(compressionQuality: 1)
//        if (imageData == nil) {
//            print("UIImageJPEGRepresentation return nil")
//            return
//        }
//
//        let body = NSMutableData()
//        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
//        body.append(NSString(format: "Content-Disposition: form-data; name=\"api_token\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
//        body.append(NSString(format: (UserDefaults.standard.string(forKey: "api_token")! as NSString)).data(using: String.Encoding.utf8.rawValue)!)
//        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
//        body.append(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"testfromios.jpg\"\r\n").data(using: String.Encoding.utf8.rawValue)!)
//        body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
//        body.append(imageData!)
//        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
//
//        request.httpBody = body as Data
//
//        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
//            (data, response, error) -> Void in
//            if let responseData = data, let plainResponse = String(data: responseData, encoding: .utf8) {
//            print("Response: " + plainResponse)
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        })
//
//        task.resume()
//    }
    
