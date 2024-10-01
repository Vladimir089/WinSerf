//
//  ProfileViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import UIKit
import Combine
import CombineCocoa

class ProfileViewController: UIViewController {
    
    private lazy var cancellable = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView()
    }
    
    private func settingsView() {
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        title = "Profile"
        settingNavBar()
    }
    
    private func settingNavBar() {
        let leftNavButton = createNavButton(image: .settings)
        self.navigationItem.leftBarButtonItem = leftNavButton
        leftNavButton.tapPublisher
            .sink { _ in
                self.settingsButtonTapped()
            }
            .store(in: &cancellable)
        
        
        let rightNavButton = createNavButton(image: .addNew)
        self.navigationItem.rightBarButtonItem = rightNavButton
        rightNavButton.tapPublisher
            .sink { _ in
                self.createNewButtonTapped()
            }
            .store(in: &cancellable)
        
        if let navigationBar = self.navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    private func createNavButton(image: UIImage) -> UIBarButtonItem {
        let navButton = UIBarButtonItem(image: image.resize(targetSize: CGSize(width: 26, height: 22)), style: .done, target: self, action: nil)
        return navButton
    }
    
    private func settingsButtonTapped() {
        let vc = SettingsViewController()
        self.present(vc, animated: true)
    }
     
    private func createNewButtonTapped() {
        print("create equip")
    }
    

}
