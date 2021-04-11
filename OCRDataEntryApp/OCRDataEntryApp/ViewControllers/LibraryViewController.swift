//
//  LibraryViewController.swift
//  OCRDataEntryApp
//
//  Created by Justin Janice on 4/11/21.
//  Copyright © 2021 SparkBU. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Library Did Load")
        
        guard let token = UserDefaults.standard.string(forKey: "tokenValue"),
              let type = UserDefaults.standard.string(forKey: "tokenType") else {
                return
              }
        
        let apiCall = RetrieveCcfAPI(baseURL: Config.baseURL, token: token, type: type)
        apiCall.retrieveFiles()
    }
}
