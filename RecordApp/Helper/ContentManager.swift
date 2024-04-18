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
    
    // keyword 매개변수에 값을 넣어주지 않으면 전체검색이 됨
    func read(keyword: String? = nil) -> [Content] {
        do {
            let realm = try Realm()
            let contents = realm.objects(Content.self)
                .sorted(byKeyPath: "createDate", ascending: false)
            
            guard let keyword = keyword,
                  keyword.isNotEmpty else {
                return Array(contents)
            }
            
            return contents.filter { $0.memo?.contains(keyword ) ?? false }
            
        } catch {
            print("Failed create ContentObject: \(error)")
        }
        return []
    }
    
    func filterDate(date: Date) {
        do {
            let realm = try Realm()
//            let filterDates = realm.filter
        } catch {
            print("Failed create ContentObject: \(error)")
        }
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
    
    func delete(content: Content) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(content)
            }
        } catch {
            print("Failed create ContentObject: \(error)")
        }
    }
}
