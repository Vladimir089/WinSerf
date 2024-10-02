//
//  EditProfileViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 02.10.2024.
//

import UIKit
import Combine
import CombineCocoa

class EditProfileViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    var mainModel: ProfileViewModel?
    private lazy  var cancellables = [AnyCancellable]()
    private var collection: UICollectionView?
    
    private lazy  var saveButton =  UIBarButtonItem(image: UIImage.okButton.resize(targetSize: CGSize(width: 26, height: 22)),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(saveButtonTapped))
    
    
    private lazy var imageView = UIImageView(image: UIImage.addImageView)
    private var textFieldsArray: [UITextField] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsNav()
    }
    
    @objc private func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        let image: Data = imageView.image?.jpegData(compressionQuality: 0) ?? Data()
        let name: String = textFieldsArray[0].text ?? ""
        let lenght: Double = Double(textFieldsArray[1].text ?? "0.0") ?? 0.0
        let volume: Int = Int(textFieldsArray[2].text ?? "") ?? 0
        let type: String = textFieldsArray[3].text ?? ""
        let speed: Int = Int(textFieldsArray[4].text ?? "") ?? 0
        
        let board = Board(image: image, name: name, lenght: lenght, volume: volume, type: type, speed: speed)
        
        mainModel?.setBoard(board: board)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fillArrTextFields()
        setView()
    }
    
    private func settingsNav() {
        title = "Board"
        let backButton = UIBarButtonItem(image: UIImage.backButton.resize(targetSize: CGSize(width: 26, height: 22)),
                                         style: .plain,
                                         target: self,
                                         action: #selector(handleBackButton))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem =  saveButton
        
        saveButton.isEnabled = false
        saveButton.customView?.alpha = 0.5
    }
    
    
    
    private func setView() {
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            collection.showsVerticalScrollIndicator = false
            collection.backgroundColor = .white
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            collection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        })
        
        let hideKBGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(hideKBGesture)
        hideKBGesture.tapPublisher
            .sink { _ in
                self.hideKB()
            }
            .store(in: &cancellables)
    }
    
    private func fillArrTextFields() {
        let arrTexts = [("Name ", " "), ("Length ", " m"), ("Volume ", " v"), ("Type ", " "), ("Speed ", " m/s")]
        
        
        for i in arrTexts {
            let label = UILabel()
            label.text = i.0
            label.textColor = .black
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            
            let textField = UITextField()
            textField.backgroundColor = .white
            textField.textAlignment = .right
            textField.textColor = .customBlue
            textField.leftView = label
            textField.leftViewMode = .always
            textField.font = .systemFont(ofSize: 13, weight: .semibold)
            textField.delegate = self
            
            let placeholderLabel = UILabel()
            placeholderLabel.text = i.1
            placeholderLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
            placeholderLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            textField.rightView = placeholderLabel
            textField.rightViewMode = .always
            
            textFieldsArray.append(textField)
        }
        
        textFieldsArray[2].keyboardType = .numberPad
        textFieldsArray[4].keyboardType = .numberPad
        
        if mainModel?.board != nil {
            textFieldsArray[0].text = mainModel?.board?.name
            textFieldsArray[1].text = String(mainModel?.board?.lenght ?? 0)
            textFieldsArray[2].text = String(mainModel?.board?.volume ?? 0)
            textFieldsArray[3].text = mainModel?.board?.type
            textFieldsArray[4].text = String(mainModel?.board?.speed ?? 0)
            imageView.image = UIImage(data: mainModel?.board?.image ?? Data())
        }
    }
    
    
    private func hideKB() {
        view.endEditing(true)
    }
    
    
    private func checkButton() {
        for i in textFieldsArray {
            if (i.text?.count ?? 0 <= 0) && (imageView.image == .addImageView) {
                saveButton.customView?.alpha = 0.5
                saveButton.isEnabled = false
                return
            }
        }
        saveButton.customView?.alpha = 1
        saveButton.isEnabled = true
    }
    
    private func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            checkButton()
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//сделать сохранение

extension EditProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 9
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        
        if indexPath.row == 0 {
            imageView.backgroundColor = .white
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = 9
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.right.top.bottom.equalToSuperview()
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: nil)
            imageView.addGestureRecognizer(tapGesture)
            tapGesture.tapPublisher
                .sink { _ in
                    self.setImage()
                }
                .store(in: &cancellables)
        } else {
            cell.addSubview(textFieldsArray[indexPath.row - 1])
            textFieldsArray[indexPath.row - 1].snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
                make.height.equalTo(33)
            }
            let sepView = UIView()
            sepView.backgroundColor = .customBlue
            cell.addSubview(sepView)
            sepView.snp.makeConstraints { make in
                make.height.equalTo(0.5)
                make.left.right.equalTo( textFieldsArray[indexPath.row - 1])
                make.bottom.equalTo( textFieldsArray[indexPath.row - 1])
            }
            
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.bounds.width - 30, height: 176)
        } else {
            return CGSize(width: collectionView.bounds.width - 30, height: 60)
        }
    }
    
}


extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField ==  textFieldsArray[3] || textField ==  textFieldsArray[4] {
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
}
