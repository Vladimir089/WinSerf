//
//  CreateEditTricksViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 04.10.2024.
//

import UIKit
import Combine
import CombineCocoa

class CreateEditTricksViewController: UIViewController {
    
    var model: SwimViewModel?
    var isNew = true
    var index = 0
    
    private lazy var cancellable = [AnyCancellable]()
    
    private lazy var textFieldsArray: [UITextField] = []
    private lazy var dateButton = UIButton(type: .system)
    private lazy var addingTricks: [NewTrick] = []
    
    
    private var collection: UICollectionView?
    private lazy var addButton = UIButton(type: .system)
    private lazy var noTricksView = UIView()
    
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
        title = "Tricks"
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
        checkIsnew()
    }
    
    private func save() {
        let distance: String = textFieldsArray[0].text ?? ""
        let time: String = textFieldsArray[1].text ?? ""
        let wind: String = textFieldsArray[2].text ?? ""
        let date: String = dateButton.titleLabel?.text ?? ""
        
        let item = Tricks(distance: distance, time: time, wind: wind, date: date, tricks: addingTricks)
        model?.saveTrick(item: item, isNew: isNew, index: index)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func createInterface() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(280)
        }
        
        let distance = fillStackView(field: textFieldsArray[0])
        stackView.addArrangedSubview(distance)
        
        let time = fillStackView(field: textFieldsArray[1])
        stackView.addArrangedSubview(time)
        
        let wind = fillStackView(field: textFieldsArray[2])
        stackView.addArrangedSubview(wind)
        
        let viewDate = UIView()
        viewDate.backgroundColor = .white
        viewDate.layer.cornerRadius = 9
        viewDate.layer.shadowColor = UIColor.black.cgColor
        viewDate.layer.shadowOpacity = 0.25
        viewDate.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewDate.layer.shadowRadius = 4
        viewDate.layer.masksToBounds = false
        
        let dateLabel = UILabel()
        dateLabel.text = "Date"
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 17, weight: .regular)
        viewDate.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        }
        
        
        stackView.addArrangedSubview(viewDate)
        
        dateButton.backgroundColor = .white
        dateButton.layer.borderColor = UIColor.customBlue.cgColor
        dateButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        dateButton.setTitleColor(.customBlue, for: .normal)
        dateButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        dateButton.layer.cornerRadius = 9
        dateButton.layer.borderWidth = 0.5
        
        viewDate.addSubview(dateButton)
        dateButton.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        
        viewDate.addSubview(hiddenTextField)
        hiddenTextField.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(dateButton)
        }
        
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
                self.checkButton()
                self.view.endEditing(true)
            }
            .store(in: &cancellable)
        hiddenTextField.isHidden = true
        
        let tricksLabel = UILabel()
        tricksLabel.textColor = .black
        tricksLabel.text = "Tricks"
        tricksLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        view.addSubview(tricksLabel)
        tricksLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).inset(-15)
            make.centerX.equalToSuperview()
        }
        
        addButton.setBackgroundImage(.addButtonCell, for: .normal)
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.height.width.equalTo(32)
            make.centerY.equalTo(tricksLabel)
        }
        
        noTricksView.backgroundColor = .clear
        view.addSubview(noTricksView)
        noTricksView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(140)
            make.top.equalTo(tricksLabel.snp.bottom).inset(-15)
        }
        
        addButton.tapPublisher
            .sink { _ in
                self.addNewTrick()
            }
            .store(in: &cancellable)
        
        
        let emptyView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 9
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
            
            let emptyLabel = UILabel()
            emptyLabel.text = "Empty"
            emptyLabel.font = .systemFont(ofSize: 20, weight: .bold)
            emptyLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
            view.addSubview(emptyLabel)
            emptyLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(10)
            }
            
            let clickLabel = UILabel()
            clickLabel.textColor = .black
            clickLabel.font = .systemFont(ofSize: 20, weight: .semibold)
            clickLabel.text = "Click to add"
            view.addSubview(clickLabel)
            clickLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(10)
            }
            
            return view
        }()
        
        noTricksView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(2)
            make.height.equalTo(80)
        }
        
        let plusButton = UIButton()
        plusButton.backgroundColor = .white
        plusButton.layer.cornerRadius = 9
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowOpacity = 0.25
        plusButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        plusButton.layer.shadowRadius = 4
        plusButton.layer.masksToBounds = false
        
        let plusImageView = UIImageView(image: .addButtonCell.resize(targetSize: CGSize(width: 32, height: 32)))
        plusButton.addSubview(plusImageView)
        plusImageView.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.center.equalToSuperview()
        }
        noTricksView.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(emptyView.snp.bottom).inset(-5)
            make.bottom.equalToSuperview()
        }
        
        plusButton.tapPublisher
            .sink { _ in
                self.addNewTrick()
            }
            .store(in: &cancellable)
        
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            collection.showsVerticalScrollIndicator = false
            collection.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(tricksLabel.snp.bottom).inset(-15)
        })
    }
    
    private func addNewTrick() {
        let alertController = UIAlertController(title: "Add", message: "Write the name of the characteristic", preferredStyle: .alert)
        alertController.addTextField()
        let cancelButton = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(cancelButton)
        
        let okButton = UIAlertAction(title: "Add", style: .default) { _ in
            
            let text = alertController.textFields?.first?.text ?? ""
            self.addingTricks.append(NewTrick(name: text, value: ""))
            self.collection?.reloadData()
            
            if self.addingTricks.count < 3 {
                self.addButton.alpha = 1
            }
            
            if self.addingTricks.count == 3 {
                self.addButton.alpha = 0
            }

            self.collection?.alpha = 1
            self.noTricksView.alpha = 0
            self.checkButton()
        }
        alertController.addAction(okButton)
        
        self.present(alertController, animated: true)
        
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
        checkButton()
    }
    
    
    
    private func fillStackView(field: UITextField) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 9
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        
        view.addSubview(field)
        field.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.center.equalToSuperview()
            make.height.equalTo(30)
        }
        
        let separator = UIView()
        separator.backgroundColor = .customBlue
        view.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(field.snp.bottom)
        }
        return view
    }

    
    private func fillArrTextFields() {
        let arrTexts = [("Distance ", " m"), ("Time ", " s"), ("Wind ", " m/s")]
        
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
            
            let placeholderLabel = UILabel()
            placeholderLabel.text = i.1
            placeholderLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
            placeholderLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            textField.rightView = placeholderLabel
            textField.rightViewMode = .always
            textField.delegate = self
            
            textFieldsArray.append(textField)
        }
    }
    
    private func checkButton() {
        for i in textFieldsArray {
            if i.text?.count ?? 0 <= 0 {
                saveButton.isEnabled = false
                saveButton.customView?.alpha = 0
                return
            }
        }
        if addingTricks.count <= 0 {
            saveButton.isEnabled = false
            saveButton.customView?.alpha = 0
            return
        }
        
        saveButton.isEnabled = true
        saveButton.customView?.alpha = 1
        
    }
    
    private func createTextField(textLeft: String) -> UITextField {
        let label = UILabel()
        label.text = textLeft
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textAlignment = .right
        textField.delegate = self
        textField.textColor = .customBlue
        textField.leftView = label
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: 13, weight: .semibold)
        textField.placeholder = "0"
        return textField
    }
    
    private func checkIsnew() {
        if isNew == false {
            textFieldsArray[0].text = model?.tricksArr[index].distance
            textFieldsArray[1].text = model?.tricksArr[index].time
            textFieldsArray[2].text = model?.tricksArr[index].wind
            dateButton.setTitle(model?.tricksArr[index].date, for: .normal)
            addingTricks = model?.tricksArr[index].tricks ?? []
            collection?.reloadData()
        }
        
        if addingTricks.count > 0 {
            collection?.alpha = 1
            if  addingTricks.count < 3 {
                addButton.alpha = 1
            }
            noTricksView.alpha = 0
        } else {
            collection?.alpha = 0
            addButton.alpha = 0
            noTricksView.alpha = 1
        }
    }
    
    
    
}


extension CreateEditTricksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addingTricks.count
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
        
        let textField = createTextField(textLeft: addingTricks[indexPath.row].name)
        cell.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        textField.text = addingTricks[indexPath.row].value
        
        textField.textPublisher
            .sink { text in
                self.addingTricks[indexPath.row].value = text ?? ""
            }
            .store(in: &cancellable)
        
        
        let separator = UIView()
        separator.backgroundColor = .customBlue
        cell.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(0.5)
            make.top.equalTo(textField.snp.bottom)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 30, height: 60)
    }
    
}


extension CreateEditTricksViewController: UITextFieldDelegate {
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
}
