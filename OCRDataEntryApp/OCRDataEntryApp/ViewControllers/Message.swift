//
//  Message.swift
//  OCRDataEntryApp
//
//  Created by Neilkaran Rawal on 12/3/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//

import Foundation

final class Message: Codable {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
}
