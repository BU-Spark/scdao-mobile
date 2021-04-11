//
//  AccessLibraryController.swift
//  OCRDataEntryApp
//
//  Created by Justin Janice on 4/11/21.
//  Copyright © 2021 SparkBU. All rights reserved.
//

import SwiftUI
import UIKit


final class AccessLibraryController: UIViewController {
    @IBOutlet
    var imageView: UIImageView!

    override func viewDidLoad() {
          super.viewDidLoad()
          print("hello world")

//        guard let token = UserDefaults.standard.string(forKey: "tokenValue"),
//              let type = UserDefaults.standard.string(forKey: "tokenType") else {
//                return
//              }
//
//        let apiCall = RetrieveCcfAPI(baseURL: Config.baseURL, token: token, type: type)
//        apiCall.retrieveFiles()

    }
}
