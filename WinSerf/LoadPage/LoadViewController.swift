//
//  LoadViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    private lazy  var progress = 0.0
    
    private lazy var progressView = UIProgressView(progressViewStyle: .bar)
    private let colorBlack = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
    lazy var timer = Timer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { _ in  //0.07
            self.progress += 12//0.01
            UIView.animate(withDuration: 0.2) {
                self.progressView.setProgress(Float(self.progress), animated: true)
            }
            if self.progress >= 1 {
                self.timer.invalidate()
                if isBet == false {
                    if UserDefaults.standard.object(forKey: "tab") != nil {
                        self.navigationController?.setViewControllers([SegmentedControlViewController()], animated: true)
                    } else {
                       self.navigationController?.setViewControllers([OnbUserViewController()], animated: true)
                    }
                } else {
                    
                }
            }
        }
    }
            
            

    private func createInterface() {
        let imageView = UIImageView(image: .loadBG)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let logoImageVeiw = UIImageView(image: .logoLoad)
        view.addSubview(logoImageVeiw)
        logoImageVeiw.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.center.equalToSuperview()
        }
        
        progressView.progressTintColor = colorBlack
        progressView.trackTintColor = .white
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 5
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(205)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        let statusView = UIView()
        statusView.backgroundColor = .clear
        
        let progressIndicator = UIActivityIndicatorView(style: .large)
        progressIndicator.color = colorBlack
        statusView.addSubview(progressIndicator)
        progressIndicator.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        progressIndicator.startAnimating()
        
        let statusLabel = UILabel()
        statusLabel.text = "Status..."
        statusLabel.textColor = .black
        statusLabel.font = .systemFont(ofSize: 17, weight: .light)
        statusView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.left.equalTo(progressIndicator.snp.right).inset(-10)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(102)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(progressView.snp.top).inset(-10)
        }
        
    }
    
    
}
