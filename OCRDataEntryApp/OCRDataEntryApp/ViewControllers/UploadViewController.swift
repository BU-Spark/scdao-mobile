//  UploadViewController.swift
//  OCRDataEntryApp
//
//  Created by Artemis Chen on 12/1/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//  resource:https://www.youtube.com/watch?v=hg-6sOOxeHA
//  Loading Indicator/Pending alert code borrowed from:
//      https://stackoverflow.com/questions/27960556/loading-an-overlay-when-running-long-tasks-in-ios (Published 12/14/15 by user Ajinkya Patil)

import SwiftUI
import UIKit

final class UploadViewController: UIViewController {
    @IBOutlet
    var imageView: UIImageView!
    var timer: Timer?
    let pending = UIAlertController(title: nil, message: "Uploading Image...", preferredStyle: .alert) //loading alert
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    let maxAPICalls = 30 //max number of API calls to check upload status
    var apiCallCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapCameraButton(){ //option to use camera when using actual device to test
        #if !targetEnvironment(simulator)
        var button = sender as UIButton
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        present(vc, animated: true)
        #endif
    }
    @IBAction func didTapLibraryButton(){ //button to open up iPhone library
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    private func toHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func didTapUploadButton(){
        let vc = UIImagePickerController()

        present(vc, animated: true, completion: nil )
        
    }
    
    
}

extension UploadViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//            imageView.image = image
//            picker.dismiss(animated: true, completion:nil)
//

        
        //https://stackoverflow.com/questions/44153941/prevent-picking-the-same-photo-twice-in-uiimagepickercontroller
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            guard !picker.isBeingDismissed else {
                print("Multiple taps to a single photo")
                return
            }
            imageView.image = image
            picker.dismiss(animated: true)
            
        
            guard let token = UserDefaults.standard.string(forKey: "tokenValue"),
                  let type = UserDefaults.standard.string(forKey: "tokenType") else {
                return
            }
            
            let apiCall = ImageAPI(baseURL: Config.baseURL, token: token, type: type)
            
            let _: () = apiCall.uploadImage(imageToUpload: imageView.image!) { status in //upload image and get job_id or API response
                if (status == nil){
                    DispatchQueue.main.async {
                        self.showAlert(field: "Error Uploading Image", info: "Please try again.")
                    }
                    return
                }
                if (status == "Unauthorized Access"){
                    DispatchQueue.main.async {
                        self.showAlert(field: "Unauthorized Access", info: "You do not have authorization to upload documents.")
                    }
                    return
                }
                if (status == "Invalid Params"){
                    DispatchQueue.main.async {
                        self.showAlert(field: "Invalid File Upload", info: "Uploaded file does not match the valid parameters.")
                    }
                    return
                }
                if (status == "Server Error"){
                    DispatchQueue.main.async {
                        self.showAlert(field: "Server Error", info: "")
                    }
                    return
                }
                
                else{ // return job_id
                    DispatchQueue.main.async {
                        self.loadingIndicator.hidesWhenStopped = true
                        self.loadingIndicator.style = UIActivityIndicatorView.Style.medium
                        self.loadingIndicator.startAnimating();
                        
                        self.pending.view.addSubview(self.loadingIndicator)
                        self.present(self.pending, animated: false, completion: nil)
                        
                        //timer function calls statusHandler() repeatedly until upload returns SUCCESS, FAIL, or max number of requests exceeded
                        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.statusHandler(sender:)), userInfo: status, repeats: true)
                    }
                }
            }
            
        } 
    }
    
    // called by timer to fetch upload status until SUCCESS or FAIL (timer invalidates upon SUCCESS or FAIL)
    @objc private func statusHandler(sender: Timer) {
        guard let token = UserDefaults.standard.string(forKey: "tokenValue"),
              let type = UserDefaults.standard.string(forKey: "tokenType") else {
            return
        }
        
        let jobID = sender.userInfo
        let apiCall = ImageAPI(baseURL: Config.baseURL, token: token, type: type)
        apiCallCount += 1
        
        apiCall.uploadStatus(task_id: jobID as! String){ status in // get status using job_id
            if let status = status{
                //                print("STATUS: ", status) // returns status (useful for debugging)
                if (status == "SUCCESS"){
                    self.timer?.invalidate()
                    self.timer = nil
                    self.apiCallCount = 0
                    DispatchQueue.main.async {
                        self.pending.dismiss(animated: false, completion:{
                            self.showAlert(field: "Upload Successful", info: "Document uploaded successfully")
                        })
                    }
                }
                
                if (status == "AWS_FAIL"){
                    self.timer?.invalidate()
                    self.timer = nil
                    self.apiCallCount = 0
                    DispatchQueue.main.async {
                        self.pending.dismiss(animated: false, completion:{
                            self.showAlert(field: "Upload Failed", info: "Document upload failed. Please try again.")
                        })
                    }
                }
                if (status == "OCR_FAIL"){
                    self.timer?.invalidate()
                    self.timer = nil
                    self.apiCallCount = 0
                    DispatchQueue.main.async {
                        self.pending.dismiss(animated: false, completion:{
                            self.showAlert(field: "Document Processing Failed", info: "Please try again.")
                        })
                    }
                }
                else{
                    if (self.apiCallCount == self.maxAPICalls){
                        self.timer?.invalidate()
                        self.timer = nil 
                        self.apiCallCount = 0
                        DispatchQueue.main.async {
                            self.pending.dismiss(animated: false, completion:{
                                self.showAlert(field: "Upload Timed Out", info: "Please try again.")
                            })
                        }
                    }
                }
            }
            else{
                self.timer?.invalidate()
                self.timer = nil
                self.apiCallCount = 0
                DispatchQueue.main.async {
                    self.pending.dismiss(animated: false, completion:{
                        self.showAlert(field: "Server Error", info: "")
                    })
                }
                
            }
            
        }
    }
    
    func showAlert(field: String, info: String) {
        let alert = UIAlertController(title: field, message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
