//
//  Untitled.swift
//  Test
//
//  Created by vaskov on 30.04.2025.
//

import UIKit
import SnapKit
import AlamofireImage


class CharTableCell: BaseTableViewCell {
    enum CellType {
        case first, center, last, loading
    }
    
    var char: CharacterModels.Char? {
        didSet {
            update()
        }
    }
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.purple1.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        contentView.addSubview(view)
        return view
    }()
    
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptLabel)
        return stackView
    }()
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()

        cellImageView.af.cancelImageRequest()
        cellImageView.image = nil
        titleLabel.text = ""
        descriptLabel.text = ""
    }
    
    private func update() {
        guard let char else { return }
        
        titleLabel.text = char.name
        descriptLabel.text = char.descript
        
        if let imageStr = char.image, let url = URL(string: imageStr) {
            cellImageView.af.setImage(withURL: url)
        }
    }
    
    override func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(5)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        cellImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(10)
            make.width.equalTo(cellImageView.snp.height)
            make.left.greaterThanOrEqualTo(stackView.snp.right).offset(10)
        }
    }
}
