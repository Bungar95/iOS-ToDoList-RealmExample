//
//  ListTableViewCell.swift
//  ToDoList
//
//  Created by Borna Ungar on 03.11.2021..
//

import Foundation
import UIKit

class ToDoListTableViewCell: UITableViewCell {
    
    let itemLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(itemId: Int, itemContent: String) {
        itemLabel.text = itemContent
    }
    
}

private extension ToDoListTableViewCell {
    
    func setupUI() {
        contentView.addSubviews(views: itemLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        itemLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
}
