//
//  Database.swift
//  Runner
//
//  Created by 近松和矢 on 2021/12/25.
//

import Foundation
import SQLite

let FILE_NAME = "main.db"

class Database {
    var db: Connection
    
    init() {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(FILE_NAME).path
        db = try! Connection(filePath)
    }
}
