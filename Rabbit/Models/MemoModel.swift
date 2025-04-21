//
//  MemoModel.swift
//  Rabbit
//
//  Created by 조수원 on 4/19/25.
//

import Foundation
import SwiftData

//swiftData 사용을 위한 데이터 모델
@Model
class Memo {
    var userID: String
    var title: String
    var content: String
    var deleted = false
    
    init(userID: String, title: String, content: String, deleted: Bool = false) {
        self.userID = userID
        self.title = title
        self.content = content
        self.deleted = false
    }
}
