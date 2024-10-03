//
//  EmptySwim.swift
//  WinSerf
//
//  Created by Владимир Кацап on 03.10.2024.
//

import UIKit

class EmptySwim: UIView {
    
    let item: String
    
    init(item: String) {
        self.item = item
        super.init(frame: .zero)
        create()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func create() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        layer.cornerRadius = 9
        
        let emptyLabel = UILabel()
        emptyLabel.text = "Empty"
        emptyLabel.textColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
        emptyLabel.font = .systemFont(ofSize: 20, weight: .bold)
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        
        let mainLabel = UILabel()
        mainLabel.textColor = .black
        mainLabel.textAlignment = .center
        mainLabel.numberOfLines = 3
        mainLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        mainLabel.text = "You don't have any \(item) added yet.\nClick the button «+» to add the first\none."
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(emptyLabel.snp.bottom).inset(-10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
