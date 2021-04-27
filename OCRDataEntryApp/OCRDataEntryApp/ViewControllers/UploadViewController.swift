//
//  UploadViewController.swift
//  OCRDataEntryApp
//
//  Created by Artemis Chen on 12/1/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//  resource:https://www.youtube.com/watch?v=hg-6sOOxeHA
//
import SwiftUI
import UIKit

final class UploadViewController: UIViewController {
    @IBOutlet
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func didTapCameraButton(){
        #if !targetEnvironment(simulator)
        var button = sender as UIButton
        
//        if sender.isOn {
//                    button.isOn = true  //   MyButton(sender: UIBarButtonItem) = true
//                }
//                else {
//                   button.isOn = false  //  MyButton(sender: UIBarButtonItem) = false
//                }
//
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        present(vc, animated: true)
        #endif
    }
    @IBAction func didTapLibraryButton(){
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
//    @IBAction func showAlertButtonTapped() {
//
//        // create the alert
//        let alert = UIAlertController(title: "Upload", message: "Form has been uploaded.", preferredStyle: UIAlertController.Style.alert)
//
//        // add an action (button)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//
//        // show the alert
//        self.present(alert, animated: true, completion: nil)
//    }

    @IBAction func didTapUploadButton(){
        let vc = UIImagePickerController()
        present(vc, animated: true, completion: nil )
        
        //showAlertButtonTapped()
        //send http request here
        //let apiCall = ImageAPI(baseURL: "localhost")
        //apiCall.uploadImage(imageToUpload: imageView.image)
    }
    
}

extension UploadViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            picker.dismiss(animated: true, completion:nil)
            
            guard let token = UserDefaults.standard.string(forKey: "tokenValue"),
                  let type = UserDefaults.standard.string(forKey: "tokenType") else {
                    return
                  }
            
            let apiCall = ImageAPI(baseURL: Config.baseURL, token: token, type: type)
            
            let _: () = apiCall.uploadImage(imageToUpload: imageView.image!) { status in
                apiCall
                if let status = status{
                    print("Value", status)
                }
            }
            
        } 
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

