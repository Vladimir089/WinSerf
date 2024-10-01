//
//  SegmentedModel.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import Foundation
import UIKit


class segmentedModel {
    
    let profileViewController = UINavigationController(rootViewController: ProfileViewController())
    let swimViewController = ssViewController()

    private lazy var viewControllersArr: [UIViewController] = []
    
    init() {
        viewControllersArr = [profileViewController, swimViewController]
    }
    
    func segmentedValueChanged(index: Int) -> UIViewController {
        return viewControllersArr[index]
    }
    
}



//del

class ssViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
