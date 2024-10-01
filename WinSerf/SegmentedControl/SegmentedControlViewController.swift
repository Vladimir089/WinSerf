//
//  SegmentedControlViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import UIKit
import Combine
import CombineCocoa

class SegmentedControlViewController: UIViewController {
    
    private let model = segmentedModel()
    private var cancellable: AnyCancellable?
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Profile", "Swim"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white
        control.selectedSegmentTintColor = .customBlue
        control.layer.cornerRadius = 3
        control.layer.shadowColor = UIColor.black.cgColor
        control.layer.shadowOpacity = 0.25
        control.layer.shadowOffset = CGSize(width: 0, height: 0)
        control.layer.shadowRadius = 4
        control.layer.masksToBounds = false
        return control
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(1, forKey: "tab")
        view.backgroundColor = .white
        subscribe()
        addSegmentedControl()
    }
    
    private func subscribe() {
        cancellable = segmentedControl.selectedSegmentIndexPublisher
            .sink(receiveValue: { index in
                self.segmentedChanged(index: index)
            })
    }
    
    
    private func addSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.height.equalTo(36)
        }
        segmentedChanged(index: 0)
    }
    
    
    private func segmentedChanged(index: Int) {
        let vc = model.segmentedValueChanged(index: index)
        addChildVC(vc)
    }
    
    private func addChildVC(_ childVC: UIViewController) {
        removeChildViewController()
        addChild(childVC)
        childVC.view.frame = view.bounds
        view.insertSubview(childVC.view, belowSubview: segmentedControl)
        childVC.didMove(toParent: self)
    }
    
    private func removeChildViewController() {
        if let currentVC = children.last {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
    }
    
}



