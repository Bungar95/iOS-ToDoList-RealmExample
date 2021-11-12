//
//  Item.swift
//  ToDoList
//
//  Created by Borna Ungar on 06.11.2021..
//

import Foundation
import RealmSwift
class Item: Object {
    
    @Persisted(primaryKey: true) var itemId: Int = 0
    @Persisted var itemValue: String = ""
    @Persisted var isDone: Bool = false
    @Persisted var createdAt: Date? = Date()
    @Persisted var updatedAt: Date?

}
