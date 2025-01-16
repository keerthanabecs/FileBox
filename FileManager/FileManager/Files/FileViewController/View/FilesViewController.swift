//
//  FilesViewController.swift
//  FileManager
//
//  Created by Keerthana on 16/01/25.
//

import UIKit

class FilesViewController: UIViewController, UINavigationControllerDelegate {
    
    var filesCollectionView: UICollectionView!
    var addFilesBtn: UIButton!
    var titleLabel: UILabel!
    var containerView: UIView!
    var noFilesLabel: UILabel!
    var backButton: UIButton!
    var viewModel: FileViewModel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitleView()
        setupContainerView()
        setupCollectionView()
        setupAddButton()
        setupConstrains()
        viewModel.fetchFiles(folderName: viewModel.folder?.folderName ?? "")
        titleLabel.text = viewModel.folder?.folderName
        viewModel.updateFilesView = {
            self.reloadCollectionView()
        }
    }
    
    func setupContainerView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        noFilesLabel = UILabel()
        noFilesLabel.text = "No files have been created yet."
        noFilesLabel.numberOfLines = 2
        noFilesLabel.lineBreakMode = .byWordWrapping
        noFilesLabel.textColor = .gray
        noFilesLabel.textAlignment = .center
        noFilesLabel.translatesAutoresizingMaskIntoConstraints = false
        noFilesLabel.font = UIFont.systemFont(ofSize: 18)
        containerView.addSubview(noFilesLabel)
    }
    
    func setupTitleView() {
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Files"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        backButton.tintColor = .black
        view.addSubview(backButton)
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        filesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filesCollectionView.delegate = self
        filesCollectionView.dataSource = self
        filesCollectionView.backgroundColor = .white
        filesCollectionView.register(FilesCollectionViewCell.self, forCellWithReuseIdentifier: FilesCollectionViewCell.identifier)
        containerView.addSubview(filesCollectionView)
    }
    
    func setupAddButton() {
        addFilesBtn = UIButton(type: .system)
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
        addFilesBtn.configuration = config
        addFilesBtn.translatesAutoresizingMaskIntoConstraints = false
        addFilesBtn.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        view.addSubview(addFilesBtn)
    }
    
    func setupConstrains() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filesCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            filesCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            filesCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            filesCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            noFilesLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -30),
            noFilesLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            noFilesLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            noFilesLabel.heightAnchor.constraint(equalToConstant: 80),
            
            addFilesBtn.heightAnchor.constraint(equalToConstant: 50),
            addFilesBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addFilesBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addFilesBtn.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func addButtonAction() {
        addFilesBtn.isHidden = true
        pickImage()
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func pickImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func reloadCollectionView() {
        if let folder = viewModel.folder {
            viewModel.fetchFiles(folderName: folder.folderName ?? "")
            DispatchQueue.main.async { [self] in
                if viewModel.files.count == 0 {
                    filesCollectionView.isHidden = true
                    noFilesLabel.isHidden = false
                } else {
                    filesCollectionView.isHidden = false
                    noFilesLabel.isHidden = true
                }
                self.filesCollectionView.reloadData()
            }
        }
    }
    
    func showAlert(title: String, msg: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:  {_ in
                completion?()
            }))
            self.present(alertController, animated: true)
        }
    }
}

extension FilesViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if let imageURL = info[.imageURL] as? URL {
                let fileName = imageURL.lastPathComponent
                print("Picked image file name: \(fileName)")
                viewModel.savePickedImage(image: pickedImage, fileName: fileName) { success,msg in
                    if success {
                        self.reloadCollectionView()
                    } else {
                        print("Error saving image.")
                    }
                }
            } else {
                print("No image URL found.")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Files collectionView delegate and datasource
extension FilesViewController : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilesCollectionViewCell.identifier, for: indexPath) as? FilesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupFile(fileDetail: viewModel.files[indexPath.row], _index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (filesCollectionView.frame.size.width - 48)/2, height: 150)
    }
    
}
