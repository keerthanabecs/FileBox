//
//  ViewController.swift
//  FileManager
//
//  Created by Keerthana on 13/01/25.
//

import UIKit

class FolderViewController: UIViewController {
    
    var folderCollectionView: UICollectionView!
    var addFolderBtn: UIButton!
    var folderCreationDialog: FolderCreationDialog!
    private var viewModel: FolderViewModel!
    var folders: [FolderEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FolderViewModel()
        setupCollectionView()
        setupAddButton()
        setupConstrains()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        folderCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        folderCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        folderCollectionView.delegate = self
//        folderCollectionView.dataSource = self
        folderCollectionView.backgroundColor = .white
        folderCollectionView.register(UINib(nibName: "foldersCell", bundle: nil), forCellWithReuseIdentifier : "foldersCell")
        view.addSubview(folderCollectionView)
    }
    
    func setupAddButton() {
        addFolderBtn = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Add"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .capsule
        addFolderBtn.configuration = config
        addFolderBtn.translatesAutoresizingMaskIntoConstraints = false
        addFolderBtn.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        view.addSubview(addFolderBtn)
    }
    
    func setupCreationDialog() {
        folderCreationDialog = FolderCreationDialog()
        folderCreationDialog.translatesAutoresizingMaskIntoConstraints = false
        folderCreationDialog.createButton.addTarget(self, action: #selector(createFolderAction), for: .touchUpInside)
        folderCreationDialog.cancelButton.addTarget(self, action: #selector(cancalBtnAction), for: .touchUpInside)
        self.view.addSubview(folderCreationDialog)
        self.view.bringSubviewToFront(folderCreationDialog)
        NSLayoutConstraint.activate([
        folderCreationDialog.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        folderCreationDialog.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        folderCreationDialog.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
        folderCreationDialog.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    
    func setupConstrains() {
        NSLayoutConstraint.activate([
            folderCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            folderCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            folderCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            folderCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addFolderBtn.heightAnchor.constraint(equalToConstant: 50),
            addFolderBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addFolderBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addFolderBtn.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func addButtonAction() {
        setupCreationDialog()
    }
    
    @objc func createFolderAction() {
        if let name = folderCreationDialog.textField.text {
            viewModel?.createFolder(folderName: name)
            folders = viewModel!.folderEntities
        } else {
            print("please enter folder name")
        }
    }
    
    @objc func cancalBtnAction() {
    }

}

//extension FolderViewController : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return folders.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = self.folderCollectionView.dequeueReusableCell(withReuseIdentifier: "foldersCell", for: indexPath) as! foldersCell
//        cell.folderName.text = self.folders[indexPath.row].folderName
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: self.folderCollectionView.frame.size.height)
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//    }
//    
//}


