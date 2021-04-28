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
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Form screen loaded")
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
