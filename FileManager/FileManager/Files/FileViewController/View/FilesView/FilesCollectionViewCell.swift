//
//  FilesCollectionViewCell.swift
//  FileManager
//
//  Created by Keerthana on 16/01/25.
//

import UIKit

class FilesCollectionViewCell: UICollectionViewCell {
    
    var titleStackView: UIStackView!
    var containerView: UIView!
    var thumbnail: UIImageView!
    var titleLabel: UILabel!
    var titleImageView: UIImageView!
    
    var moredelegate: MoreOptionDelegate?
    var index: Int!
    static let identifier = "FilesCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        thumbnail = UIImageView()
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.contentMode = .scaleAspectFill
        
        thumbnail.image = UIImage(named: "image")
        
        titleImageView = UIImageView()
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = UIImage(named: "image")
        titleImageView.tintColor = .gray
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .black
        
        titleStackView = UIStackView(arrangedSubviews: [titleImageView,titleLabel])
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.spacing = 5
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(titleStackView)
        containerView.addSubview(thumbnail)
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            titleImageView.widthAnchor.constraint(equalToConstant: 40),
            titleStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleStackView.heightAnchor.constraint(equalToConstant: 30),
            containerView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thumbnail.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            thumbnail.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            thumbnail.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            thumbnail.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            thumbnail.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    
    func setupFile(fileDetail: FileEntity, _index: Int) {
        let fileName = fileDetail.fileName
        let folderName = fileDetail.folder?.folderName
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(folderName ?? "").appendingPathComponent(fileName ?? "")
        if let image = UIImage(contentsOfFile: fileURL.path) {
            thumbnail.image = image
        } else {
            print("Failed to load image from path: \(fileURL.path)")
        }
        titleLabel.text = fileDetail.fileName
        index = _index
    }
}
