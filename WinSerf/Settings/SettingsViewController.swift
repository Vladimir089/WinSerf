//
//  SettingsViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import UIKit
import Combine
import CombineCocoa
import StoreKit
import WebKit

class SettingsViewController: UIViewController {
    
    private lazy var appURL = "url"
    private lazy var policyURL = "https://www.google.com"
    
    private lazy var cancellable = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        createInterface()
    }
    

    private func createInterface() {
        
        let hideView = UIView()
        hideView.backgroundColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.4)
        hideView.layer.cornerRadius = 2.5
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
        }
        
        let closeButton = UIButton(type: .system)
        closeButton.setBackgroundImage(.closeSettings, for: .normal)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(hideView.snp.bottom).inset(-10)
        }
        closeButton.tapPublisher
            .sink { _ in
                self.dismiss(animated: true)
            }
            .store(in: &cancellable)
        
        let topLabel = UILabel()
        topLabel.text = "Settings"
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 20, weight: .bold)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom)
        }
        
        createAndSettingButton(topLabel: topLabel)
    }
    
    private func createAndSettingButton(topLabel: UILabel) {
        
        let rateButton = createButton(title: "Rate App")
        view.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(69)
            make.top.equalTo(topLabel.snp.bottom).inset(-15)
        }
        rateButton.tapPublisher
            .sink { _ in
                self.rateApps()
            }
            .store(in: &cancellable)
        
        let shareButton = createButton(title: "Share App")
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(69)
            make.top.equalTo(rateButton.snp.bottom).inset(-10)
        }
        shareButton.tapPublisher
            .sink { _ in
                self.shareApps()
            }
            .store(in: &cancellable)
        
        let policyButton = createButton(title: "Usage Policy")
        view.addSubview(policyButton)
        policyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(69)
            make.top.equalTo(shareButton.snp.bottom).inset(-10)
        }
        policyButton.tapPublisher
            .sink { _ in
                self.policy()
            }
            .store(in: &cancellable)
    }
    
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .customBlue
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 9
        button.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        return button
    }
    

    private func rateApps() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: appURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    private func shareApps() {
        let appURL = URL(string: appURL)!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // Настройка для показа в виде popover на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func policy() {
        let webVC = WebViewController()
        webVC.urlString = policyURL
        present(webVC, animated: true, completion: nil)
    }
}

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
