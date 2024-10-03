//
//  NewEditSpeedViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 03.10.2024.
//

import UIKit
import Combine
import CombineCocoa

class NewEditSpeedViewController: UIViewController {
    
    var model: SwimViewModel?
    var isNew = true
    var index = 0
    
    private lazy var cancellable = [AnyCancellable]()
    //ui
    private lazy var textFieldsArray: [UITextField] = []
    private lazy var dateButton = UIButton(type: .system)
    
    private let datePicker = UIDatePicker()
    private let hiddenTextField = UITextField()
    
    private lazy  var saveButton =  UIBarButtonItem(image: UIImage.okButton.resize(targetSize: CGSize(width: 26, height: 22)),
                                                    style: .plain,
                                                    target: self,
                                                    action: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsNav()
    }
    
    @objc private func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func settingsNav() {
        title = "Speed"
        let backButton = UIBarButtonItem(image: UIImage.backButton.resize(targetSize: CGSize(width: 26, height: 22)),
                                         style: .plain,
                                         target: self,
                                         action: #selector(handleBackButton))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem =  saveButton
        
        saveButton.isEnabled = false
        saveButton.customView?.alpha = 0.5
        
        saveButton.tapPublisher
            .sink { _ in
                self.save()
            }
            .store(in: &cancellable)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        fillArrTextFields()
        createInterface()
        checkIsNew()
    }
    
    private func save() {
        let distance: String = textFieldsArray[0].text ?? ""
        let speed: String = textFieldsArray[1].text ?? ""
        let time: String = textFieldsArray[2].text ?? ""
        let wind: String = textFieldsArray[3].text ?? ""
        let date: String = dateButton.titleLabel?.text ?? ""
        
        let newSpeed = Speed(distance: distance, speed: speed, time: time, wind: wind, date: date)
        
        model?.saveSpeed(item: newSpeed, isNew: isNew, index: index)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func createInterface() {
        let collection: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.backgroundColor = .clear
            layout.scrollDirection = .vertical
            collection.delegate = self
            collection.dataSource = self
            collection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            return collection
        }()
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
        }
        
        dateButton.backgroundColor = .white
        dateButton.layer.borderColor = UIColor.customBlue.cgColor
        dateButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        dateButton.setTitleColor(.customBlue, for: .normal)
        dateButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        dateButton.layer.cornerRadius = 9
        dateButton.layer.borderWidth = 0.5
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        dateButton.setTitle(formattedDate, for: .normal)
        
        dateButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        hiddenTextField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        hiddenTextField.inputAccessoryView = toolbar
        
        let hideKBGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(hideKBGesture)
        hideKBGesture.tapPublisher
            .sink { _ in
                self.checkSaveBUtton()
                self.view.endEditing(true)
            }
            .store(in: &cancellable)
    }
    
    @objc private func showDatePicker() {
        hiddenTextField.becomeFirstResponder()
    }
    
    @objc private func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy" // Формат: Jun 20, 2023
        let formattedDate = dateFormatter.string(from: datePicker.date)
        dateButton.setTitle(formattedDate, for: .normal)
        hiddenTextField.resignFirstResponder()
    }
    
    
    private func fillArrTextFields() {
        let arrTexts = [("Distance ", " m"), ("Speed ", " m/s"), ("Time ", " s"), ("Wind ", " m/s")]
        
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
            textField.placeholder = "0"
            textField.delegate = self
            
            let placeholderLabel = UILabel()
            placeholderLabel.text = i.1
            placeholderLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
            placeholderLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            textField.rightView = placeholderLabel
            textField.rightViewMode = .always
            
            textFieldsArray.append(textField)
        }
    }
    
    private func checkSaveBUtton() {
        for item in textFieldsArray {
            if item.text?.count ?? 0 <= 0 {
                saveButton.isEnabled = false
                saveButton.customView?.alpha = 0.5
                return
            }
        }
        saveButton.isEnabled = true
        saveButton.customView?.alpha = 1
    }
    
    private func checkIsNew() {
        if !isNew {
            textFieldsArray[0].text = model?.speedArr[index].distance
            textFieldsArray[1].text = model?.speedArr[index].speed
            textFieldsArray[2].text = model?.speedArr[index].time
            textFieldsArray[3].text = model?.speedArr[index].wind
            dateButton.setTitle(model?.speedArr[index].date, for: .normal)
        }
    }
    
}


extension NewEditSpeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textFieldsArray.count + 1
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
        
        if indexPath.row != textFieldsArray.count {
            cell.addSubview(textFieldsArray[indexPath.row])
            textFieldsArray[indexPath.row].snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(10)
                make.height.equalTo(30)
                make.center.equalToSuperview()
            }
            let separator = UIView()
            separator.backgroundColor = .customBlue
            cell.addSubview(separator)
            separator.snp.makeConstraints { make in
                make.height.equalTo(0.5)
                make.left.right.equalToSuperview().inset(10)
                make.top.equalTo(textFieldsArray[indexPath.row].snp.bottom)
            }
        }
        
        if indexPath.row == textFieldsArray.count {
            let dateLabel = UILabel()
            dateLabel.text = "Date"
            dateLabel.textColor = .black
            dateLabel.font = .systemFont(ofSize: 17, weight: .regular)
            cell.addSubview(dateLabel)
            dateLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
            }
            
            cell.addSubview(dateButton)
            dateButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(10)
                make.height.equalTo(34)
            }
            
            cell.addSubview(hiddenTextField)
            hiddenTextField.isHidden = true
            hiddenTextField.snp.makeConstraints { make in
                make.edges.equalTo(dateButton)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 30, height: 60)
    }
    
}


extension NewEditSpeedViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkSaveBUtton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkSaveBUtton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkSaveBUtton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkSaveBUtton()
        return true
    }
}
