//
//  ImageApi.swift
//  OCRDataEntryApp
//  Code borrowed from https://stackoverflow.com/questions/37474265/swift-2-how-do-you-add-authorization-header-to-post-request 
//  and https://stackoverflow.com/questions/26335656/how-to-upload-images-to-a-server-in-ios-with-swift
//
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
