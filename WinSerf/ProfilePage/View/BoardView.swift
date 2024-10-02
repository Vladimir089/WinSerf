//
//  BoardView.swift
//  WinSerf
//
//  Created by Владимир Кацап on 02.10.2024.
//

import UIKit

class BoardView: UIView {
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(.edit, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    func createView(board: Board) {
       let topLabel = UILabel()
        topLabel.text = "Board"
        topLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        topLabel.textColor = .black
        addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let mainView = UIView()
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 9
        mainView.layer.cornerRadius = 16
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.25
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 4
        mainView.layer.masksToBounds = false
        
        addSubview(mainView)
        mainView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).inset(-10)
            make.height.equalTo(185)
        })
        
        let imageView = UIImageView(image: UIImage(data: board.image))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.backgroundColor = .white
        mainView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(10)
            make.height.equalTo(132)
            make.width.equalTo(128)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        mainView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-5)
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(imageView)
            make.bottom.equalTo(imageView.snp.bottom).inset(5)
        }
        
        let lenghtView = createLabels(text: String(board.lenght), subText: " m", mainText: "Length")
        let volumeView = createLabels(text: String(board.volume), subText: " v", mainText: "Volume")
        let typeView = createLabels(text: board.type, subText: "", mainText: "Type")
        let speedView = createLabels(text: String(board.speed), subText: " m/s", mainText: "Speed")
        
        stackView.addArrangedSubview(lenghtView)
        stackView.addArrangedSubview(volumeView)
        stackView.addArrangedSubview(typeView)
        stackView.addArrangedSubview(speedView)
        
        let nameLabel = UILabel()
        nameLabel.text = board.name
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        mainView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.left.equalToSuperview().inset(10)
        }
        
        mainView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.right.bottom.equalToSuperview().inset(10)
        }
        
        let equimpLabel = UILabel()
        equimpLabel.text = "Equipment"
        equimpLabel.textColor = .black
        equimpLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        addSubview(equimpLabel)
        equimpLabel.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.bottom).inset(-15)
            make.centerX.equalToSuperview()
        }
    }
    
    private func createLabels(text: String, subText: String, mainText: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        
        let labelLeft = UILabel()
        labelLeft.text = mainText
        labelLeft.textColor = .black
        labelLeft.font = .systemFont(ofSize: 13, weight: .semibold)
        view.addSubview(labelLeft)
        labelLeft.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        let subTextLabel = UILabel()
        subTextLabel.text = subText
        subTextLabel.textColor = .customBlue
        subTextLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        view.addSubview(subTextLabel)
        subTextLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let label = UILabel()
        label.text = text
        label.textColor = .customBlue
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(subTextLabel.snp.left)
        }
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = .customBlue
        view.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        return view
    }
    
}
