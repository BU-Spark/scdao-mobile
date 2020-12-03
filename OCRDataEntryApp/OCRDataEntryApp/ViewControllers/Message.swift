//
//  Message.swift
//  OCRDataEntryApp
//
//  Created by Neilkaran Rawal on 12/3/20.
//  Copyright © 2020 SparkBU. All rights reserved.
//

import Foundation

final class Message: Codable {
    let username: String
    let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
}
