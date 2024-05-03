//
//  Content.swift
//  RecordApp
//
//  Created by se-ryeong on 1/15/24.
//

import Foundation
import RealmSwift

class Content: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var memo: String?
    @Persisted var createDate: Date?
    
    override class func primaryKey() -> String? {
         "id"
    }
    
    convenience init(id: ObjectId = ObjectId.generate(), memo: String? = nil, createDate: Date? = nil) {
        self.init()
        self.id = id
        self.memo = memo
        self.createDate = createDate
    }
}
