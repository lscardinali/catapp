//
//  Item.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
