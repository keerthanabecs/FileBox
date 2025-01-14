//
//  IconLabelCell.swift
//  FileManager
//
//  Created by Keerthana on 14/01/25.
//

import UIKit

class IconLabelCell: UITableViewCell {
    
    static let identifier = "IconLabelCell"
    
    var stackView: UIStackView!
    var iconImage: UIImageView!
    var menuLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        iconImage = UIImageView()
        iconImage.contentMode = .scaleAspectFit
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        
        menuLabel = UILabel()
        menuLabel.font = UIFont.systemFont(ofSize: 16)
        menuLabel.textColor = .label
        menuLabel.textAlignment = .left
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView = UIStackView(arrangedSubviews: [iconImage,menuLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            iconImage.widthAnchor.constraint(equalToConstant: 20),
            iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            menuLabel.heightAnchor.constraint(equalToConstant: 45),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 10),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func configure(image: UIImage, title: String) {
        iconImage.image = image
        iconImage.tintColor = .black
        menuLabel.text = title
    }
    
}

