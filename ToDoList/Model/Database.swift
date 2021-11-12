//
//  Database.swift
//  ToDoList
//
//  Created by Borna Ungar on 06.11.2021..
//

import Foundation
import RealmSwift

class Database {
    
    static let singleton = Database()
    private init() {}
    
    func createOrUpdate(toDoItemValue: String) -> (Void) {
        
        let realm = try! Realm()
        
        var toDoId: Int? = 1
        
        if let lastEntity = realm.objects(Item.self).last {
            toDoId = lastEntity.itemId + 1
        }
        
        let itemEntity = Item()
        itemEntity.itemId = toDoId!
        itemEntity.itemValue = toDoItemValue
        
        try! realm.write {
            realm.add(itemEntity, update: .all)
        }
        
    }
    
    func fetch() -> (Results<Item>) {
        
        let realm = try! Realm()
        
        let itemResults = realm.objects(Item.self)
        
        return itemResults
    }
    
    func delete(primaryKey: Int) -> (Void) {
        
        let realm = try! Realm()
        
        if let itemEntity = realm.object(ofType: Item.self, forPrimaryKey: primaryKey) {
            try! realm.write{
                realm.delete(itemEntity)
            }
        }
        
    }
}
