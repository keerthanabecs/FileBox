//
//  FolderCell.swift
//  FileManager
//
//  Created by Keerthana on 13/01/25.
//

import UIKit

protocol MoreOptionDelegate {
    func moreButtonTapped(index: Int)
}

class FolderCell: UICollectionViewCell {
    
    var titleStackView: UIStackView!
    var containerView: UIView!
    var folderImageView: UIImageView!
    var titleLabel: UILabel!
    var titleImageView: UIImageView!
    var moreButton: UIButton!
    var favoriteImage: UIImageView!
    
    var moredelegate: MoreOptionDelegate?
    var index: Int!
    static let identifier = "FolderCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFolderImageView() {
        folderImageView = UIImageView()
        folderImageView.translatesAutoresizingMaskIntoConstraints = false
        folderImageView.contentMode = .scaleAspectFit
        folderImageView.image = UIImage(systemName: "folder")
        containerView.addSubview(folderImageView)
    }

    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .black
    }

    func setupUI() {
        contentView.backgroundColor = UIColor(red: 237/255.0, green: 241/255.0, blue: 239/255.0, alpha: 1.0)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.masksToBounds = false
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        
        folderImageView = UIImageView()
        folderImageView.translatesAutoresizingMaskIntoConstraints = false
        folderImageView.contentMode = .scaleAspectFit
        folderImageView.image = UIImage(named: "folder")

        titleImageView = UIImageView()
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = UIImage(named: "folder")
        titleImageView.tintColor = .gray
        
        favoriteImage = UIImageView()
        favoriteImage.translatesAutoresizingMaskIntoConstraints = false
        favoriteImage.contentMode = .scaleAspectFit
        favoriteImage.image = UIImage(named: "star")
        favoriteImage.isHidden = true
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .black
        
        moreButton = UIButton(type: .system)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setImage(UIImage(named: "more"), for: .normal)
        moreButton.tintColor = .gray
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        titleStackView = UIStackView(arrangedSubviews: [titleImageView,titleLabel,moreButton])
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.spacing = 5
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(titleStackView)
        folderImageView.addSubview(favoriteImage)
        containerView.addSubview(folderImageView)
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            titleImageView.widthAnchor.constraint(equalToConstant: 40),
            moreButton.widthAnchor.constraint(equalToConstant: 30),
            titleStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleStackView.heightAnchor.constraint(equalToConstant: 30),
            containerView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            favoriteImage.widthAnchor.constraint(equalToConstant: 20),
            favoriteImage.heightAnchor.constraint(equalToConstant: 20),
            favoriteImage.centerXAnchor.constraint(equalTo: folderImageView.centerXAnchor),
            favoriteImage.centerYAnchor.constraint(equalTo: folderImageView.centerYAnchor, constant: 5),
            folderImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            folderImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            folderImageView.widthAnchor.constraint(equalToConstant: 80),
            folderImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.75)
        ])
    }
    
    func setupFolder(folderDetail: FolderEntity, _index: Int) {
        folderImageView.tintColor = ColorConverter.hexToColor(hex: folderDetail.folderColor ?? "#808080")
        titleImageView.tintColor = folderImageView.tintColor
        titleLabel.text = folderDetail.folderName
        favoriteImage.isHidden = !folderDetail.isFavorite
        index = _index
    }
    
    @objc func moreButtonTapped() {
        moredelegate?.moreButtonTapped(index: index)
    }
}
