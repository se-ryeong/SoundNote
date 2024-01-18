//
//  ContentManager.swift
//  RecordApp
//
//  Created by se-ryeong on 1/15/24.
//

import Foundation
import RealmSwift

class ContentManager {
    func create(content: Content) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(content)
            }
        } catch {
            print("Failed create ContentObject: \(error)")
        }
    }
    
    func read() -> [Content] {
        do {
            let realm = try Realm()
            let contents = realm.objects(Content.self).sorted(byKeyPath: "createDate", ascending: false)
            return Array(contents)
        } catch {
            print("Failed create ContentObject: \(error)")
        }
        return []
    }
    
    func update(content: Content, completion: @escaping (Content) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                completion(content)
            }
        } catch {
            print("Failed create ContentObject: \(error)")
        }
    }
}
