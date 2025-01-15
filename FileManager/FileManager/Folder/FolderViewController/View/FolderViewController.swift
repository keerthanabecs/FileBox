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
    var titleLabel: UILabel!
    var containerView: UIView!
    var noFoldersLabel: UILabel!
    var filterBtn: UIButton!
    var sortTableView: UITableView!
    
    var filterBtnWidth: CGFloat!
    var folderCreationDialog: FolderCreationDialog!
    var selectedSortType: SortType!
    private var viewModel: FolderViewModel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = FolderViewModel()
        viewModel.delegate = self
        setupTitleView()
        setupContainerView()
        setupCollectionView()
        setupAddButton()
        setupSortTable()
        setupConstrains()
        setupCreationDialog()
        reloadCollectionView()
    }
    
    func setupContainerView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        noFoldersLabel = UILabel()
        noFoldersLabel.text = "No folders have been created yet."
        noFoldersLabel.textColor = .gray
        noFoldersLabel.textAlignment = .center
        noFoldersLabel.translatesAutoresizingMaskIntoConstraints = false
        noFoldersLabel.font = UIFont.systemFont(ofSize: 18)
        containerView.addSubview(noFoldersLabel)
    }
    
    func setupTitleView() {
        filterBtn = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Sort"
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        filterBtn.configuration = config
        filterBtn.contentHorizontalAlignment = .leading
        filterBtn.translatesAutoresizingMaskIntoConstraints = false
        filterBtn.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "File Manager"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        view.addSubview(filterBtn)
        view.addSubview(titleLabel)
    }
    
    
    func setupSortTable() {
        viewModel.loadSortMenu()
        sortTableView = UITableView()
        sortTableView.translatesAutoresizingMaskIntoConstraints = false
        sortTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        sortTableView.register(IconLabelCell.self, forCellReuseIdentifier:  IconLabelCell.identifier)
        sortTableView.delegate = self
        sortTableView.dataSource = self
        sortTableView.rowHeight = UITableView.automaticDimension
        sortTableView.estimatedRowHeight = 30
        view.addSubview(sortTableView)
        sortTableView.isHidden = true
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
        containerView.addSubview(folderCollectionView)
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
        view.addSubview(folderCreationDialog)
        folderCreationDialog.isHidden = true
        NSLayoutConstraint.activate([
            folderCreationDialog.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            folderCreationDialog.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            folderCreationDialog.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            folderCreationDialog.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func setupConstrains() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            filterBtn.heightAnchor.constraint(equalToConstant: 40),
            filterBtn.widthAnchor.constraint(equalToConstant: 120),
            filterBtn.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            filterBtn.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            sortTableView.topAnchor.constraint(equalTo: filterBtn.topAnchor),
            sortTableView.leadingAnchor.constraint(equalTo: filterBtn.trailingAnchor),
            sortTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            sortTableView.heightAnchor.constraint(equalToConstant: 200),
            
            containerView.topAnchor.constraint(equalTo: filterBtn.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            folderCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            folderCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            folderCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            folderCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            noFoldersLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -30),
            noFoldersLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            noFoldersLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            noFoldersLabel.heightAnchor.constraint(equalToConstant: 80),
            
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
                showFolderList()
            } else {
                print("please enter folder name")
            }
        }
    }
    
    func reloadCollectionView() {
       if defaults.string(forKey: "sortType") == nil {
           viewModel.fetchFolders()
       } else {
           viewModel.fetchSortedFolder()
           let titleStr = viewModel.getTitle(for: viewModel.selectedSort ?? .dateAsc)
           changeButtonTitle(newTitle: titleStr!)
       }
        DispatchQueue.main.async { [self] in
            if viewModel.folderEntities.count == 0 {
                folderCollectionView.isHidden = true
                noFoldersLabel.isHidden = false
            } else {
                folderCollectionView.isHidden = false
                noFoldersLabel.isHidden = true
            }
            self.folderCollectionView.reloadData()
        }
    }
    
    func showFolderList() {
        folderCreationDialog.isHidden = true
        addFolderBtn.isHidden = false
        reloadCollectionView()
    }
    
    @objc func cancalBtnAction() {
        showFolderList()
    }
    
    @objc func filterBtnTapped() {
        self.sortTableView.isHidden = false
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

//MARK: - Folder collectionView delegate and datasource
extension FolderViewController : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.folderEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.identifier, for: indexPath) as? FolderCell else {
            return UICollectionViewCell()
        }
        cell.setupFolder(folderDetail: viewModel.folderEntities[indexPath.row], _index: indexPath.row)
        cell.moredelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (folderCollectionView.frame.size.width - 48)/2, height: 150)
    }
    
}

//MARK: - Menu button delegate
extension FolderViewController: MoreOptionDelegate {
    func moreButtonTapped(index: Int) {
        viewModel.selectedRow = index
        let menuVC = FolderMenuView()
        menuVC.viewModel.folder = viewModel.folderEntities[index]
        menuVC.delegate = self
        menuVC.modalPresentationStyle = .overCurrentContext
        self.present(menuVC, animated: true)
    }
}

//MARK: - Folder create delegation
extension FolderViewController: FolderDelegate {
    func didFailed(msg: String) {
        showAlert(title: "Error", msg: msg)
        
    }
    
    func didFolderColorChanged() {
        showAlert(title: "Success", msg: "Folder Color Changes Successfully") {
            self.reloadCollectionView()
        }
        
    }
    
    func didFolderDeleted() {
        showAlert(title: "Success", msg: "Folder Deleted Successfully") {
            self.reloadCollectionView()
        }
    }
    
    func didFolderStarred() {
        showAlert(title: "Success", msg: "Folder Marked Successfully") {
            self.reloadCollectionView()
        }
    }
    
    func didFolderCreationSuccessfully(msg: String) {
        showAlert(title: "Success", msg: msg)
    }
}

//MARK: -Menupage delegate
extension FolderViewController: FolderMenuDelegate {
    func didMenuTapped(type: MenuType) {
        if type == .starred {
            viewModel.updateisFavorite()
        } else if type == .changeColor {
            showColorPicker()
        } else if type == .delete {
            viewModel.deleteFolder()
        }
    }
    
    func didFavoriteTapped() {
        viewModel.updateisFavorite()
    }
    
    func didColorChageTapped() {
        showColorPicker()
    }
    
    func showColorPicker() {
        DispatchQueue.main.async {
            let colorPicker = UIColorPickerViewController()
            colorPicker.delegate = self
            self.present(colorPicker, animated: true)
        }
    }
}

//MARK: colorpicker delegate
extension FolderViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        if color != .white && color != . black {
            let hexColor = ColorConverter.colorToHex(color: color)
            viewModel.updateFolderColor(color: hexColor)
        }
    }
}

//MARK: - tableview delegate and datasource

extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortMenu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sortTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.sortMenu[indexPath.row].title
        let sortType = viewModel.sortMenu[indexPath.row].sortType
        let sortTypeRawValue = defaults.string(forKey: "sortType") ?? SortType.dateAsc.rawValue
        let selectedSortType = SortType(rawValue: sortTypeRawValue) ?? .dateAsc
        if sortType == selectedSortType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.textAlignment = .left
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortType = viewModel.sortMenu[indexPath.row].sortType
        sortTableView.reloadData()
        saveSortOption(sortType: sortType)
        changeButtonTitle(newTitle: viewModel.sortMenu[indexPath.row].title)
        tableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func saveSortOption(sortType: SortType) {
        defaults.set(sortType.rawValue, forKey: "sortType")
        reloadCollectionView()
    }
    
    func changeButtonTitle(newTitle: String) {
        var config = filterBtn.configuration
        config?.title = "SortBy: \(newTitle)"
        filterBtn.configuration = config
        let title = "SortBy: \(newTitle)"
        let titleSize = (title as NSString).size(withAttributes: [
            .font: UIFont.systemFont(ofSize: 16)
        ])
        filterBtn.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                filterBtn.removeConstraint(constraint)
            }
        }
        filterBtn.widthAnchor.constraint(equalToConstant: titleSize.width + 30).isActive = true
    }
}
