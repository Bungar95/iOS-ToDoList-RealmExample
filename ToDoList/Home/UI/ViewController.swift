//
//  ViewController.swift
//  CoffeeBreak
//
//  Created by Borna Ungar on 29.10.2021..
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
import RealmSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "To Do List"
        return label
    }()
    
    let emptyNoticeLabel: UILabel = {
        let label = UILabel()
        label.text = "Your list is currently empty."
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    let itemTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "What do you want to add to the list?"
        return field
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to list", for: .normal)
        button.backgroundColor = .systemTeal
        return button
    }()
    
    let toDoTableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    let viewModel: ToDoListViewModel
    
    init(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupButtons()
        initializeVM()
        viewModel.loadListSubject.onNext(())
    }
    
}

private extension ViewController {
    
    func setupTableView() {
        registerCells()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
    }
    
    func setupUI(){
        view.backgroundColor = .white
        view.addSubviews(views: progressView, titleLabel, itemTextField, addButton, toDoTableView, emptyNoticeLabel)
        view.bringSubviewToFront(progressView)
        setupConstraints()
        
    }
    
    func setupConstraints(){
        
        progressView.snp.makeConstraints{ (make) -> Void in
            make.centerX.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        itemTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(itemTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        toDoTableView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(addButton.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyNoticeLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(addButton.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    func registerCells() {
        toDoTableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: "toDoListTableViewCell")
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: "toDoListTableViewCell", for: indexPath) as? ToDoListTableViewCell else {
            print("failed to dequeue the wanted cell")
            return UITableViewCell()
        }
        
        let items = viewModel.listRelay.value
        let item = items[indexPath.row]
        itemCell.configureCell(itemId: item.itemId, itemContent: item.itemValue)
        
        return itemCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = viewModel.listRelay.value
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = viewModel.listRelay.value
        let item = items[indexPath.row]
        viewModel.deleteItem(id: item.itemId)
        viewModel.loadListSubject.onNext(())
    }
    
}

private extension ViewController {
    
    func setupButtons() {
        
        addButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                if let text = itemTextField.text{
                    if !text.isEmpty {
                    viewModel.addItem(value: text)
                    viewModel.loadListSubject.onNext(())
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func initializeVM() {
        disposeBag.insert(viewModel.initializeViewModelObservables())
        
        initializeLoaderObservable(subject: viewModel.loaderSubject).disposed(by: disposeBag)
        initializeListDataObservable(subject: viewModel.listRelay).disposed(by: disposeBag)
        
    }
    
    func initializeLoaderObservable(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (status) in
                if status {
                    showLoader()
                } else {
                    hideLoader()
                }
            })
    }
    
    func initializeListDataObservable(subject: BehaviorRelay<[Item]>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (tasks) in
                if !tasks.isEmpty {
                    emptyNoticeLabel.isHidden = true
                } else {
                    emptyNoticeLabel.isHidden = false
                }
                toDoTableView.reloadData()
            })
    }
}

extension ViewController {
    
    func showLoader() {
        progressView.isHidden = false
        progressView.startAnimating()
    }
    
    func hideLoader() {
        progressView.isHidden = true
        progressView.stopAnimating()
    }
}
