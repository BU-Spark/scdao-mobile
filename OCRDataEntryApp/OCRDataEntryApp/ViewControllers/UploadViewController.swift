//
//  UploadViewController.swift
//  OCRDataEntryApp
//
//  Created by Artemis Chen on 12/1/20.
//  Copyright © 2020 SparkBU. All rights reserved.
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
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        present(vc, animated: true)
    }
    @IBAction func didTapLibraryButton(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    @IBAction func didTapUploadButton(){
        let vc = UIImagePickerController()
        present(vc, animated: true, completion: nil)
        //send http request here
    }
    
}

extension UploadViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion:nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
        } 
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

