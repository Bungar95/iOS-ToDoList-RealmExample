//
//  ToDoListViewModelImpl.swift
//  ToDoList
//
//  Created by Borna Ungar on 03.11.2021..
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ToDoListViewModelImpl: ToDoListViewModel {    
    
    private let listRepository: ToDoListRepository
    
    var listRelay = BehaviorRelay<[Item]>.init(value: [])
    
    var loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var loadListSubject = ReplaySubject<()>.create(bufferSize: 1)
    
    init(listRepository: ToDoListRepository) {
        self.listRepository = listRepository
    }
    
    func initializeViewModelObservables() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(initializeListSubject(subject: loadListSubject))
        return disposables
    }
    
    func addItem(value: String) {
        self.listRepository.addUpdateToList(item: value)
    }
    
    func deleteItem(id: Int) {
        self.listRepository.deleteFromList(itemId: id)
    }
}

private extension ToDoListViewModelImpl {
    
    func initializeListSubject(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { _ in
                self.loaderSubject.onNext(true)
                let tasks = self.listRepository.fetchList()
                self.listRelay.accept(tasks)
                self.loaderSubject.onNext(false)
            })
    }
}
