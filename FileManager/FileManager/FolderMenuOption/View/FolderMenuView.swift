//
//  FolderMenuView.swift
//  FileManager
//
//  Created by Keerthana on 14/01/25.
//

import UIKit

class FolderMenuView: UIViewController {
    
    var tableView: UITableView!
    var viewModel: FolderMenuViewModel!
    var foldeNameLbl: UILabel!
    var containerView: UIView!
    var index: Int!
    var titleStack: UIStackView!
    var closeButton: UIButton!
    var foldername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FolderMenuViewModel()
        viewModel.loadMenus()
        setup()
    }

    func setup() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners =  [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(containerView)
        
        foldeNameLbl = UILabel()
        foldeNameLbl.font = UIFont.systemFont(ofSize: 18)
        foldeNameLbl.textColor = .black
        foldeNameLbl.textAlignment = .center
        foldeNameLbl.text = foldername
        foldeNameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        titleStack = UIStackView(arrangedSubviews: [foldeNameLbl,closeButton])
        titleStack.axis = .horizontal
        titleStack.distribution = .fill
        titleStack.spacing = 15
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleStack)
        
        view.backgroundColor = .black.withAlphaComponent(0.2)
        
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(IconLabelCell.self, forCellReuseIdentifier:  IconLabelCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        containerView.addSubview(tableView)
        
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.foldeNameLbl.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            titleStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleStack.heightAnchor.constraint(equalToConstant: 40),
            titleStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func showColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
}

//MARK:- tableview del
extension FolderMenuView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IconLabelCell.identifier, for: indexPath) as! IconLabelCell
        let menu = viewModel.menus[indexPath.row]
        cell.configure(image: menu.icon, title: menu.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = viewModel.menus[indexPath.row]
        if menu.menuType == .changeColor {
            showColorPicker()
        }
            viewModel.selectMenu(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension FolderMenuView: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        let hexColor = ColorConverter.colorToHex(color: color)
        print("folder name \(viewModel.folderEntity?.folderName ?? "") && folderpath \(viewModel.folderEntity?.folderPath ?? "") hex color \(hexColor)")
    }
    
}
