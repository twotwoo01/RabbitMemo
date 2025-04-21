//
//  Item.swift
//  Rabbit
//
//  Created by 조수원 on 4/19/25.
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
