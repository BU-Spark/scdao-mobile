//
//  DocumentsViewController.swift
//  OCRDataEntryApp
//
//  Created by Victor Figueroa on 11/11/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//

import Foundation
import UIKit

class DocumentsViewController: UIViewController {
    
    @IBAction func CriminalCompliantFormIsClicked(_ sender: Any) {
        //Make API request that this form is has been selected, then open the scanner
        //https://github.com/weirdindiankid/scdao-api-1/blob/master/backend/app/crud/cc_crud.py
        self.performSegue(withIdentifier: "UploadViewSegue", sender: self)
    }
    @IBAction func ApplicationForCriminalComplaintFormIsClicked(_ sender: Any) {
        //Make API request that this form is has been selected, then open the scanner
        self.performSegue(withIdentifier: "UploadViewSegue", sender: self)
    }
    @IBAction func IncidentReportFormIsClicked(_ sender: Any) {
        //Make API request that this form is has been selected, then open the scanner
        self.performSegue(withIdentifier: "UploadViewSegue", sender: self)
    }
    @IBAction func ArrestBookingFormIsClicked(_ sender: Any) {
        //Make API request that this form is has been selected, then open the scanner
        self.performSegue(withIdentifier: "UploadViewSegue", sender: self)
    }
    @IBAction func MirandaFormIsClicked(_ sender: Any) {
        //Make API request that this form is has been selected, then open the scanner
        self.performSegue(withIdentifier: "UploadViewSegue", sender: self)
    }
    @IBAction func ProbationRecordFormIsClicked(_ sender: Any) {
        //Make API request that this form is has been selected, then open the scanner
        self.performSegue(withIdentifier: "UploadViewSegue", sender: self)
    }
    
    private func toHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
