//
//  FormViewController.swift
//  OCRDataEntryApp
//
//  Created by Jana Mikaela Aguilar on 4/13/21.
//  Copyright © 2021 SparkBU. All rights reserved.
//

import SwiftUI
import UIKit
class FormViewController: UIViewController {
    let controller = UIHostingController(rootView: FormView())
    @State var records: [Form] = []
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Api2().getData() { (records) in
            self.records = records
            if(records[0].docket == "Nil return"){
                    
                    let alert = UIAlertController(title: "Backend error", message: "Not connected to backend", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }

        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        

        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
