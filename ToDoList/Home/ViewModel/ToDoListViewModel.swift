//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Borna Ungar on 03.11.2021..
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ToDoListViewModel: AnyObject {
    
    var listRelay: BehaviorRelay<[Item]> {get}
    
    var loaderSubject: ReplaySubject<Bool> {get}
    var loadListSubject: ReplaySubject<()> {get}
    
    func initializeViewModelObservables() -> [Disposable]
    func addItem(value: String)
    func deleteItem(id: Int)
}
