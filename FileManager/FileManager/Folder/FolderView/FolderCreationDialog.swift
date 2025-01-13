//
//  FolderCreationDialog.swift
//  FileManager
//
//  Created by Keerthana on 13/01/25.
//

import UIKit

class FolderCreationDialog: UIView {
    var titleLabel: UILabel!
    var textField: UITextField!
    var buttonStackView: UIStackView!
    var createButton: UIButton!
    var cancelButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.text = "New Folder"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter folder name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        createButton = UIButton()
        createButton.setTitle("Create", for: .normal)
        createButton.layer.cornerRadius = 8
        createButton.setTitleColor(.black, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.layer.cornerRadius = 8
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)

//        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView = UIStackView(arrangedSubviews: [createButton, cancelButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        self.addSubview(textField)
        self.addSubview(buttonStackView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 60),
           
            buttonStackView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: textField.widthAnchor, multiplier: 0.55),
            buttonStackView.heightAnchor.constraint(equalToConstant: 30),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}
