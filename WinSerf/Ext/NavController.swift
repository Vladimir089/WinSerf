//
//  NavController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
