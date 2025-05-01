//
//  BaseView.swift
//  Test
//
//  Created by vaskov on 29.04.2025.
//

import UIKit


class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView?.setNeedsLayout()
        backgroundView?.layoutIfNeeded()
    }
    
    func configureUI() {
    }
}
