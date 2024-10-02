//
//  EquipmentViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 02.10.2024.
//

import UIKit
import Combine
import CombineCocoa

class EquipmentViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    var isNew = true
    var index = 0
    var mainModel: ProfileViewModel?
    private lazy  var cancellables = [AnyCancellable]()
    
    private lazy  var saveButton =  UIBarButtonItem(image: UIImage.okButton.resize(targetSize: CGSize(width: 26, height: 22)),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(saveButtonTapped))
    
    //UI
    private var collection: UICollectionView?
    private var mainImageView = UIImageView(image: .addImageView)
    private var nameTextField = UITextField()
    private var descriptionTextView = UITextView()
    private var characteristics: [Character] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsNav()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        settingsNav()
        createInterface()
        checkIsNew()
    }
    
    private func checkIsNew() {
        nameTextField = createTextField(text: "Name")
        if isNew == false {
            let item = mainModel?.equipmentArr[index]
            mainImageView.image = UIImage(data: item?.image ?? Data())
            nameTextField.text = item?.name ?? ""
            descriptionTextView.text = item?.description ?? ""
            characteristics = item?.characteristics ?? []
            collection?.reloadData()
        }
    }
    
    

    @objc private func saveButtonTapped() {
        let image: Data = mainImageView.image?.jpegData(compressionQuality: 0) ?? Data()
        let name: String = nameTextField.text ?? ""
        let desk: String = descriptionTextView.text ?? ""
        
        var equipment = Equipment(image: image, name: name, description: desk, characteristics: characteristics)

        
        mainModel?.setEquipment(equipment: equipment, index: isNew ? nil : index)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func settingsNav() {
        title = "Equipment"
        let backButton = UIBarButtonItem(image: UIImage.backButton.resize(targetSize: CGSize(width: 26, height: 22)),
                                         style: .plain,
                                         target: self,
                                         action: #selector(handleBackButton))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem =  saveButton
        
        saveButton.isEnabled = false
        saveButton.customView?.alpha = 0.5
    }
    
    @objc private func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func createTextField(text: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = text
        textField.backgroundColor = .white
        textField.textColor = .customBlue
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 13, weight: .semibold)
        let leftLabel = UILabel()
        leftLabel.text = text + " "
        leftLabel.textColor = .black
        leftLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        textField.leftView = leftLabel
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }
    
    
    private func createInterface() {
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            collection.showsVerticalScrollIndicator = false
            collection.backgroundColor = .white
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            collection.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        })
        
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 7
        mainImageView.isUserInteractionEnabled = true
        
        descriptionTextView.textColor = .customBlue
        descriptionTextView.backgroundColor = .white
        descriptionTextView.font = .systemFont(ofSize: 13, weight: .semibold)
        descriptionTextView.textContainer.maximumNumberOfLines = 2
        descriptionTextView.isEditable = true
        descriptionTextView.delegate = self
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        tapGesture.tapPublisher
            .sink { _ in
                self.view.endEditing(true)
            }
            .store(in: &cancellables)
    }
    
    private func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            mainImageView.image = pickedImage
            checkSaveButton()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .customBlue
        return view
    }
    
    private func createNewCharacter() {
        let alertController = UIAlertController(title: "Add", message: "Write the name of the characteristic", preferredStyle: .alert)
        alertController.addTextField()
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancel)
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            let name:String = alertController.textFields?.first?.text ?? ""
            self.characteristics.append(Character(name: name, value: ""))
            self.collection?.reloadData()
        }
        alertController.addAction(add)
        self.present(alertController, animated: true)
    }
    
    private func checkSaveButton() {
        if mainImageView.image != .addImageView , nameTextField.text?.count ?? 0 > 0 , descriptionTextView.text.count > 0, characteristics.count > 0 {
            saveButton.isEnabled = true
            saveButton.customView?.alpha = 1
        } else {
            saveButton.isEnabled = false
            saveButton.customView?.alpha = 0.5
        }
    }

}

extension EquipmentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collection {
            return 2
        } else {
            if characteristics.count > 0 {
                return characteristics.count
            } else {
                return characteristics.count + 2
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = .white
            
            
            if indexPath.row == 0 {
                
                let podImage = UIView()
                podImage.layer.cornerRadius = 7
                podImage.layer.shadowColor = UIColor.black.cgColor
                podImage.layer.shadowOpacity = 0.25
                podImage.layer.shadowOffset = CGSize(width: 0, height: 0)
                podImage.layer.shadowRadius = 4
                podImage.layer.masksToBounds = false
                cell.addSubview(podImage)
                podImage.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.equalToSuperview()
                    make.height.equalTo(176)
                }
                
                
                podImage.addSubview(mainImageView)
                mainImageView.snp.makeConstraints { make in
                    make.height.width.top.bottom.equalToSuperview()
                }
                let setImageGesture = UITapGestureRecognizer(target: self, action: nil)
                setImageGesture.tapPublisher
                    .sink { _ in
                        self.setImage()
                    }
                    .store(in: &cancellables)
                mainImageView.addGestureRecognizer(setImageGesture)
                
                let nameView = UIView()
                nameView.backgroundColor = .white
                nameView.layer.cornerRadius = 9
                nameView.layer.shadowColor = UIColor.black.cgColor
                nameView.layer.shadowOpacity = 0.25
                nameView.layer.shadowOffset = CGSize(width: 0, height: 0)
                nameView.layer.shadowRadius = 4
                nameView.layer.masksToBounds = false
                cell.addSubview(nameView)
                nameView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.height.equalTo(60)
                    make.top.equalTo(mainImageView.snp.bottom).inset(-15)
                }
                nameView.addSubview(nameTextField)
                nameTextField.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.height.equalTo(30)
                    make.centerY.equalToSuperview()
                }
                let separatorOneBlue = createSeparator()
                nameView.addSubview(separatorOneBlue)
                separatorOneBlue.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.bottom.equalTo(nameTextField.snp.bottom)
                    make.height.equalTo(0.5)
                }
                
                let deskView = UIView()
                deskView.backgroundColor = .white
                deskView.layer.cornerRadius = 9
                deskView.layer.shadowColor = UIColor.black.cgColor
                deskView.layer.shadowOpacity = 0.25
                deskView.layer.shadowOffset = CGSize(width: 0, height: 0)
                deskView.layer.shadowRadius = 4
                deskView.layer.masksToBounds = false
                cell.addSubview(deskView)
                deskView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.height.equalTo(102)
                    make.top.equalTo(nameView.snp.bottom).inset(-15)
                }
                
                let deskLabel = UILabel()
                deskLabel.text = "Description"
                deskLabel.textColor = .black
                deskLabel.font = .systemFont(ofSize: 13, weight: .semibold)
                deskView.addSubview(deskLabel)
                deskLabel.snp.makeConstraints { make in
                    make.left.top.equalToSuperview().inset(10)
                }
                
                deskView.addSubview(descriptionTextView)
                descriptionTextView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.height.equalTo(36)
                    make.top.equalTo(deskLabel.snp.bottom).inset(-15)
                }
                let secondSep = createSeparator()
                deskView.addSubview(secondSep)
                secondSep.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.height.equalTo(0.5)
                    make.top.equalTo(descriptionTextView.snp.bottom)
                }
                
                let characterLabel = UILabel()
                characterLabel.text = "Characteristics"
                characterLabel.textColor = .black
                characterLabel.font = .systemFont(ofSize: 20, weight: .semibold)
                cell.addSubview(characterLabel)
                characterLabel.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(deskView.snp.bottom).inset(-20)
                }
                
                let addButton = UIButton(type: .system)
                addButton.setBackgroundImage(.addButtonCell, for: .normal)
                cell.addSubview(addButton)
                addButton.snp.makeConstraints { make in
                    make.centerY.equalTo(characterLabel)
                    make.height.width.equalTo(32)
                    make.right.equalToSuperview().inset(15)
                }
                addButton.tapPublisher
                    .sink { _ in
                        self.createNewCharacter()
                    }
                    .store(in: &cancellables)
                
                addButton.isHidden = (characteristics.count > 0 && characteristics.count < 2) ? false : true
            } else {
                let secondCollection = {
                    let layout = UICollectionViewFlowLayout()
                    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
                    layout.scrollDirection = .vertical
                    collection.showsVerticalScrollIndicator = false
                    collection.backgroundColor = .white
                    collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
                    collection.delegate = self
                    collection.dataSource = self
                    collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    return collection
                }()
                cell.addSubview(secondCollection)
                secondCollection.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = .white
            
            if characteristics.count > 0 {
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
                    make.left.right.equalToSuperview().inset(10)
                    make.top.bottom.equalToSuperview().inset(2.5)
                }
                
                let textField = createTextField(text: characteristics[indexPath.row].name)
                view.addSubview(textField)
                textField.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.height.equalTo(30)
                    make.center.equalToSuperview()
                }
                textField.text = characteristics[indexPath.row].value
                
                let sepView = createSeparator()
                view.addSubview(sepView)
                sepView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.height.equalTo(0.5)
                    make.top.equalTo(textField.snp.bottom)
                }
                
                textField.textPublisher
                    .sink { text in
                        self.characteristics[indexPath.row].value = text ?? ""
                    }
                    .store(in: &cancellables)
                
            } else {
                switch indexPath.row {
                case 0:
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
                        make.top.equalToSuperview().inset(2.5)
                        make.height.equalTo(85)
                    }
                    
                    let emptyLabel = UILabel()
                    emptyLabel.text = "Empty"
                    emptyLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
                    emptyLabel.font = .systemFont(ofSize: 20, weight: .bold)
                    view.addSubview(emptyLabel)
                    emptyLabel.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.top.equalToSuperview().inset(10)
                    }
                    
                    let clickLabel = UILabel()
                    clickLabel.text = "Click to add"
                    clickLabel.textColor = .black
                    clickLabel.font = .systemFont(ofSize: 20, weight: .semibold)
                    view.addSubview(clickLabel)
                    clickLabel.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.bottom.equalToSuperview().inset(10)
                    }
                    
                case 1:

                    let button = UIButton(type: .system)
                    button.backgroundColor = .white
                    button.layer.shadowColor = UIColor.black.cgColor
                    button.layer.shadowOpacity = 0.25
                    button.layer.shadowOffset = CGSize(width: 0, height: 0)
                    button.layer.shadowRadius = 4
                    button.layer.masksToBounds = false
                    button.setImage(.addButtonCell.resize(targetSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysOriginal), for: .normal)
                    button.layer.cornerRadius = 9
                    button.backgroundColor = .white
                    cell.addSubview(button)
                    button.snp.makeConstraints { make in
                        make.left.right.equalToSuperview().inset(15)
                        make.height.equalTo(50)
                        make.centerY.equalToSuperview()
                    }
                    button.tapPublisher
                        .sink { _ in
                            self.createNewCharacter()
                        }
                        .store(in: &cancellables)
                default:
                    print(1)
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collection {
            if indexPath.row == 0 {
                return CGSize(width: collectionView.bounds.width, height: 420)
            } else {
                return CGSize(width: Int(collectionView.bounds.width), height: characteristics.count > 0 ? (characteristics.count * 75) : 160)
            }
        } else {
            if (indexPath.row == characteristics.count + 1) && (characteristics.count <= 0)  {
                return CGSize(width: collectionView.bounds.width, height: 52)
            } else {
                if characteristics.count > 0 {
                    return CGSize(width: collectionView.bounds.width, height: 70)
                } else {
                    print(12443)
                    return CGSize(width: collectionView.bounds.width, height: 90)
                }
            }
        }
    }
}


extension EquipmentViewController: UITextFieldDelegate, UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkSaveButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != nameTextField {
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -230)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
              self.view.transform = .identity
          }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkSaveButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkSaveButton()
        view.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkSaveButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkSaveButton()
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        checkSaveButton()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        checkSaveButton()
        return true
    }
}
