//
//  ToDoListRepository.swift
//  ToDoList
//
//  Created by Borna Ungar on 03.11.2021..
//

import Foundation
import RxSwift
class ToDoListRepositoryImpl: ToDoListRepository {
    
    func fetchList() -> [Item] {
        let list = Database.singleton.fetch()
        print("List fetched.")
        return Array(list)
    }
    
    func addUpdateToList(item: String){
        let taskValue = item
        Database.singleton.createOrUpdate(toDoItemValue: taskValue)
        print("Task added/updated.")
    }
    
    func deleteFromList(itemId: Int){
        let taskId = itemId
        Database.singleton.delete(primaryKey: taskId)
        print("Task deleted.")
    }
    
}

protocol ToDoListRepository: AnyObject {
    
    func fetchList() -> [Item]
    func addUpdateToList(item: String)
    func deleteFromList(itemId: Int)
}
