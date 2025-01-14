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
        setupCreationDialog()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
        folderCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        folderCollectionView.translatesAutoresizingMaskIntoConstraints = false
        folderCollectionView.delegate = self
        folderCollectionView.dataSource = self
        folderCollectionView.backgroundColor = .white
        folderCollectionView.register(FolderCell.self, forCellWithReuseIdentifier: FolderCell.identifier)
        view.addSubview(folderCollectionView)
    }
    
    func setupAddButton() {
        addFolderBtn = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Add"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .capsule
        
        if let icon = UIImage(systemName: "plus") {
            config.image = icon
            config.imagePadding = 8
            config.imagePlacement = .leading
        }
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
        folderCreationDialog.isHidden = true
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
        folderCreationDialog.isHidden = false
        addFolderBtn.isHidden = true
    }
    
    @objc func createFolderAction() {
        DispatchQueue.main.async { [self] in
            if let name = folderCreationDialog.textField.text {
                viewModel?.createFolder(folderName: name)
                folders = viewModel!.folderEntities
                self.folderCreationDialog.isHidden = true
                self.addFolderBtn.isHidden = false
                self.folderCollectionView.reloadData()
            } else {
                print("please enter folder name")
            }
        }
    }
    
    @objc func cancalBtnAction() {
        folders = viewModel!.folderEntities
        self.folderCreationDialog.isHidden = true
        self.addFolderBtn.isHidden = false
        self.folderCollectionView.reloadData()
    }
    

}

extension FolderViewController : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.identifier, for: indexPath) as? FolderCell else {
            return UICollectionViewCell()
        }
        cell.setupFolder(folderDetail: self.folders[indexPath.row], _index: indexPath.row)
        cell.moredelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (folderCollectionView.frame.size.width - 48)/2, height: 150)
    }
    
}


extension FolderViewController: MoreOptionDelegate {
    func moreButtonTapped(index: Int) {
        let menuVC = FolderMenuView()
        menuVC.index = index
        menuVC.foldername = viewModel.folderEntities[index].folderName
        menuVC.modalPresentationStyle = .overCurrentContext
        self.present(menuVC, animated: true)
    }

}
