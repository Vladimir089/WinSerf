//
//  OnbUserViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import UIKit
import CombineCocoa
import Combine

class OnbUserViewController: UIViewController {
    
    private let model = UserOnboardingViewModel()
    private lazy var cancellable = [AnyCancellable]()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView = UIImageView()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(.nextBut, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createView()
        subscribeButton()
    }
    
    private func createView() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(69)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
        next()
    }
    
    private func subscribeButton() {
        nextButton.tapPublisher
            .sink { _ in
                self.next()
            }
            .store(in: &cancellable)
    }

    private func next() {
        let startData = model.tapNextButton()
        UIView.animate(withDuration: 0.5) {
            self.imageView.image = startData.0
            self.topLabel.text = startData.1
        }
        if model.checkNextVC() {
            self.navigationController?.setViewControllers([SegmentedControlViewController()], animated: true)
        }
    }

}
