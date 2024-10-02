//
//  ProfileViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import UIKit
import Combine
import CombineCocoa

class ProfileViewController: UIViewController {

    private let viewModel = ProfileViewModel()
    
    private lazy var mainCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .white
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
        collection.delegate = self
        collection.dataSource = self
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView()
        subscribe()
    }
    
    private func subscribe() {
        viewModel.collectionPublisher
            .sink { board in
                self.mainCollection.reloadData()
            }
            .store(in: &viewModel.cancellable) 
    }
    
    private func settingsView() {
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        title = "Profile"
        settingNavBar()
        createInterface()
    }
    
    private func openEditEquipment() {
        let vc = EquipmentViewController()
        vc.mainModel = viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func settingNavBar() {
        let leftNavButton = createNavButton(image: .settings)
        self.navigationItem.leftBarButtonItem = leftNavButton
        leftNavButton.tapPublisher
            .sink { _ in
                self.settingsButtonTapped()
            }
            .store(in: &viewModel.cancellable)
        
        
        let rightNavButton = createNavButton(image: .addNew)
        self.navigationItem.rightBarButtonItem = rightNavButton
        rightNavButton.tapPublisher
            .sink { _ in
                self.openEditEquipment()
            }
            .store(in: &viewModel.cancellable)
        
        if let navigationBar = self.navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    private func createNavButton(image: UIImage) -> UIBarButtonItem {
        let navButton = UIBarButtonItem(image: image.resize(targetSize: CGSize(width: 26, height: 22)), style: .done, target: self, action: nil)
        return navButton
    }
    
    private func settingsButtonTapped() {
        let vc = SettingsViewController()
        self.present(vc, animated: true)
    }

    private func createInterface() {
        view.addSubview(mainCollection)
        mainCollection.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func editBoard() {
        let vc = EditProfileViewController()
        vc.mainModel = viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createItemFromStackView(textOne: String, textTwo: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        let leftLabel = UILabel()
        leftLabel.text = textOne
        leftLabel.textColor = .black
        leftLabel.textAlignment = .left
        leftLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        view.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(150)
        }
        
        let rightView = UILabel()
        rightView.text = textTwo
        rightView.textColor = .customBlue
        rightView.font = .systemFont(ofSize: 13, weight: .semibold)
        view.addSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
        }
        
        let separatorView = UIView()
        separatorView.backgroundColor = .customBlue
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return view
    }
    
    @objc func menuButtonTapped(sender: UIButton) {
        let firstAction = UIAction(title: "Edit", image: nil) { _ in
            self.openEditEquimp(index: sender.tag)
        }
        
        let secondAction = UIAction(title: "Delete", image: nil) { _ in
            self.deleteEq(index: sender.tag)
        }
        
        let menu = UIMenu(title: "", children: [firstAction, secondAction])
        
        if #available(iOS 14.0, *) {
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
        }
    }
    
    private func openEditEquimp(index: Int) {
        let vc = EquipmentViewController()
        vc.mainModel = viewModel
        vc.isNew = false
        vc.index = index
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func deleteEq(index: Int) {
        let alertController = UIAlertController(title: "Delete", message: "Do you really want to delete equipment?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(noAction)
        let okActrion = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.deleteEqupment(index: index)
        }
        alertController.addAction(okActrion)
        self.present(alertController, animated: true)
    }

}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollection {
            return 2
        } else {
            return viewModel.returnNumberCellsInEquipmentCollection()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            if indexPath.row == 0 {
                print(23)
                let boadView = BoardView()
                boadView.createView(board: viewModel.sendBoard())
                cell.addSubview(boadView)
                boadView.snp.makeConstraints { make in
                    make.left.right.top.bottom.equalToSuperview().inset(15)
                }
                boadView.editButton.tapPublisher
                    .sink { _ in
                        self.editBoard()
                    }
                    .store(in: &viewModel.cancellable)
            } else {
                let collectionEquipment: UICollectionView = {
                    let layout = UICollectionViewFlowLayout()
                    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
                    layout.scrollDirection = .vertical
                    collection.showsVerticalScrollIndicator = false
                    collection.backgroundColor = .white
                    collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
                    collection.delegate = self
                    collection.dataSource = self
                    return collection
                }()
                cell.addSubview(collectionEquipment)
                collectionEquipment.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            if  viewModel.equipmentArr.count > 0 && indexPath.row != viewModel.equipmentArr.count + 1 {
                cell.backgroundColor = .white
                let view = UIView()
                view.backgroundColor = .white
                view.layer.cornerRadius = 9
                view.layer.shadowColor = UIColor.black.cgColor
                view.layer.shadowOpacity = 0.25
                view.layer.shadowOffset = CGSize(width: 0, height: 0)
                view.layer.shadowRadius = 4
                view.layer.masksToBounds = false
                cell.addSubview(view)
                view.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.bottom.equalToSuperview().inset(2.5)
                }
                
                let item = viewModel.equipmentArr[indexPath.row]
                
                let imageView = UIImageView(image: UIImage(data: item.image))
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 7
                imageView.layer.borderColor =  UIColor(red: 118/255, green: 183/255, blue: 255/255, alpha: 1).cgColor
                imageView.layer.borderWidth = 0.33
                view.addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.height.equalTo(132)
                    make.width.equalTo(128)
                    make.left.top.equalToSuperview().inset(10)
                }
                
                let nameLabel = UILabel()
                nameLabel.text = item.name
                nameLabel.textColor = .black
                nameLabel.textAlignment = .left
                nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
                view.addSubview(nameLabel)
                nameLabel.snp.makeConstraints { make in
                    make.left.bottom.equalToSuperview().inset(10)
                    make.width.equalTo(150)
                }
                
                let stackView = UIStackView()
                stackView.axis = .vertical
                stackView.spacing = 3
                stackView.distribution = .fillEqually
                view.addSubview(stackView)
                stackView.snp.makeConstraints { make in
                    make.left.equalTo(imageView.snp.right).inset(-10)
                    make.right.equalToSuperview().inset(10)
                    make.top.equalTo(imageView.snp.top)
                    make.height.equalTo(item.characteristics.count > 1 ? 63 : 30)
                }
                
                if item.characteristics.count > 1 {
                    let topView = createItemFromStackView(textOne: item.characteristics[0].name, textTwo: item.characteristics[0].value)
                    let botView = createItemFromStackView(textOne: item.characteristics[1].name, textTwo: item.characteristics[1].value)
                    stackView.addArrangedSubview(topView)
                    stackView.addArrangedSubview(botView)
                } else {
                    let topView = createItemFromStackView(textOne: item.characteristics[0].name, textTwo: item.characteristics[0].value)
                    stackView.addArrangedSubview(topView)
                }
                
                let deskLabel = UILabel()
                deskLabel.numberOfLines = 3
                deskLabel.textAlignment = .left
                deskLabel.font = .systemFont(ofSize: 13, weight: .semibold)
                deskLabel.textColor = .customBlue
                deskLabel.text = item.description
                view.addSubview(deskLabel)
                deskLabel.snp.makeConstraints { make in
                    make.left.equalTo(imageView.snp.right).inset(-10)
                    make.right.equalToSuperview().inset(10)
                    make.top.equalTo(stackView.snp.bottom).inset(-10)
                    make.bottom.equalTo(imageView.snp.bottom).inset(-0.5)
                }
                
                let separatorView = UIView()
                separatorView.backgroundColor = .customBlue
                view.addSubview(separatorView)
                separatorView.snp.makeConstraints { make in
                    make.left.right.equalTo(deskLabel)
                    make.top.equalTo(deskLabel.snp.bottom)
                    make.height.equalTo(0.5)
                }
                
                let menuButton = UIButton(type: .system)
                menuButton.setBackgroundImage(.buttonMenu, for: .normal)
                view.addSubview(menuButton)
                menuButton.snp.makeConstraints { make in
                    make.height.width.equalTo(18)
                    make.right.equalToSuperview().inset(10)
                    make.centerY.equalTo(nameLabel)
                }
                menuButton.tag = indexPath.row
                
                menuButton.addTarget(self, action: #selector(menuButtonTapped(sender:)), for: .touchUpInside)
                
            } else if indexPath.row == viewModel.equipmentArr.count + 1 {
                cell.backgroundColor = .white
                let button = UIButton(type: .system)
                button.backgroundColor = .white
                
                button.layer.cornerRadius = 9
                button.layer.shadowColor = UIColor.black.cgColor
                button.layer.shadowOpacity = 0.25
                button.layer.shadowOffset = CGSize(width: 0, height: 0)
                button.layer.shadowRadius = 4
                button.layer.masksToBounds = false
                button.setImage(.addButtonCell.resize(targetSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysOriginal), for: .normal)
                cell.addSubview(button)
                button.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.height.equalToSuperview()
                    make.center.equalToSuperview()
                }
                button.tapPublisher
                    .sink { _ in
                        self.openEditEquipment()
                    }
                    .store(in: &viewModel.cancellable)
            } else {
                let view = UIView()
                view.backgroundColor = .white
                view.layer.cornerRadius = 9
                view.layer.shadowColor = UIColor.black.cgColor
                view.layer.shadowOpacity = 0.25
                view.layer.shadowOffset = CGSize(width: 0, height: 0)
                view.layer.shadowRadius = 4
                view.layer.masksToBounds = false
                
                cell.addSubview(view)
                view.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.equalToSuperview().inset(5)
                    make.bottom.equalToSuperview()
                }
                
                let labelEmpty = UILabel()
                labelEmpty.textColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
                labelEmpty.text = "Empty"
                labelEmpty.font = .systemFont(ofSize: 20, weight: .bold)
                view.addSubview(labelEmpty)
                labelEmpty.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview().inset(10)
                }
                
                let deskLabel = UILabel()
                deskLabel.text = "You don't have any equipment added yet. Click the button «+» to add the first one."
                deskLabel.numberOfLines = 3
                deskLabel.textAlignment = .center
                deskLabel.textColor = .black
                deskLabel.font = .systemFont(ofSize: 20, weight: .semibold)
                view.addSubview(deskLabel)
                deskLabel.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.bottom.equalToSuperview().inset(10)
                    make.top.equalTo(labelEmpty.snp.bottom).inset(-5)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollection {
            return CGSize(width: collectionView.bounds.width, height: viewModel.getHeightMainCollection(collectionIsMain: true, indexForCollection: indexPath.row))
        } else {
            return CGSize(width: collectionView.bounds.width, height: viewModel.getHeightMainCollection(collectionIsMain: false, indexForCollection: indexPath.row))
        }
    }
}
