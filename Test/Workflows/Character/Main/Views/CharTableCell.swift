//
//  Untitled.swift
//  Test
//
//  Created by vaskov on 30.04.2025.
//

import UIKit
import SnapKit


class CharTableCell: UITableViewCell {
    var char: Char? {
        didSet {
            update()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .purple1
        label.numberOfLines = 1
        label.textAlignment = .left
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var descriptLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .purple1
        label.numberOfLines = 1
        label.textAlignment = .left
        contentView.addSubview(label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func update() {
        guard let char else { return }
        titleLabel.text = char.name
        var descript = ""
        switch (char.gender, char.createdDate) {
        case (let gender?, let created?):
            descript = gender + "    " + (created.text(dateFormat: .date) ?? "")
        case (let gender?, nil):
            descript = gender
        case (nil, let created?):
            descript = created.text(dateFormat: .date) ?? ""
        case (nil, nil):
            descript = ""
        }
        descriptLabel.text = descript
    }
    
    private func configureUI() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        descriptLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(16)
        }
    }
}
