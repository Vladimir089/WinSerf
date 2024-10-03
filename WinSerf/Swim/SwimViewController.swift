//
//  SwimViewController.swift
//  WinSerf
//
//  Created by Владимир Кацап on 03.10.2024.
//

import UIKit
import Combine
import CombineCocoa

class SwimViewController: UIViewController {
    
    private lazy var viewModel = SwimViewModel()
    
    private var mainCollection: UICollectionView?
    private var speedCollection: UICollectionView?
    private var tricksCollection: UICollectionView?
    
    private lazy var publisher = viewModel.updateCollectionPublisher
    
    private let speedPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    private let tricksPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    
    private lazy var cancellable = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView()
        subscribe()
    }
    
    private func settingsView() {
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        title = "Swim"
        settingNavBar()
        createInterface()
    }
    
    private func subscribe() {
        publisher
            .sink { _ in
                self.speedCollection?.reloadData()
                self.tricksCollection?.reloadData()
                self.mainCollection?.reloadData()
            }
            .store(in: &viewModel.cancellable)
    }
    
    
    private func plusTapped() {
        let alertController = UIAlertController(title: "Category", message: "Select which category card you want to create", preferredStyle: .alert)
        
        let speedAction = UIAlertAction(title: "Speed", style: .default) { _ in
            let vc = NewEditSpeedViewController()
            vc.isNew = true
            vc.model = self.viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alertController.addAction(speedAction)
        
        let tricksAction = UIAlertAction(title: "Tricks", style: .default) { _ in
            print(1)
        }
        alertController.addAction(tricksAction)
        
        let closeAction = UIAlertAction(title: "Close", style: .destructive)
        alertController.addAction(closeAction)
        self.present(alertController, animated: true)
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
                self.plusTapped()
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
    
    
    private func createInterface() {
        
        mainCollection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.showsVerticalScrollIndicator = false
            collection.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
            collection.delegate = self
            collection.dataSource = self
            collection.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            return collection
        }()
        view.addSubview(mainCollection!)
        mainCollection?.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        })
        
        tricksCollection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            collection.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
            collection.delegate = self
            collection.dataSource = self
            collection.showsHorizontalScrollIndicator = false
            layout.minimumLineSpacing = 0
            collection.isPagingEnabled = true
            return collection
        }()
        tricksCollection?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "3")
        
        speedCollection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
            collection.showsVerticalScrollIndicator = false
            collection.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
            collection.delegate = self
            collection.showsHorizontalScrollIndicator = false
            collection.isPagingEnabled = true
            layout.minimumLineSpacing = 0
            collection.dataSource = self
            return collection
        }()
    }
    
    
    private func createLinsesView(textOne: String, textTwo: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        
        let leftLabel = UILabel()
        leftLabel.text = textOne
        leftLabel.textColor = .black
        leftLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        leftLabel.textAlignment = .left
        view.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(150)
        }
        
        let rightLabel = UILabel()
        rightLabel.text = textTwo
        rightLabel.textColor = .customBlue
        rightLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        rightLabel.textAlignment = .right
        view.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(150)
        }
        
        let separatorView = UIView()
        separatorView.backgroundColor = .customBlue
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return view
    }
    
    private func del(index: Int) {
        let alertController = UIAlertController(title: "Delete", message: "Do you really want to delete?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(noAction)
        
        let delAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.delSpeed(index: index)
        }
        alertController.addAction(delAction)
        self.present(alertController, animated: true)
    }
    
    
    @objc private func menuButtonTapped(_ sender: UIButton) {
        let firstAction = UIAction(title: "Edit", image: .editMenu) { _ in
            let vc = NewEditSpeedViewController()
            vc.isNew = false
            vc.index = sender.tag
            vc.model = self.viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let secondAction = UIAction(title: "Delete", image: .delMenu) { _ in
            self.del(index: sender.tag)
        }
        
        let menu = UIMenu(title: "", children: [firstAction, secondAction])
        
        if #available(iOS 14.0, *) {
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
        }
    }
    
}


extension SwimViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollection {
            return 2
        } else if collectionView == speedCollection {
            if viewModel.returnSpeedArrCount() > 0 {
                return viewModel.returnSpeedArrCount()
            } else {
                return 1
            }
        } else {
            if viewModel.returnTricksArrCount() > 0 {
                return viewModel.returnTricksArrCount()
            } else {
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
            if indexPath.row == 0 {
                let speedLabel = UILabel()
                speedLabel.textColor = .black
                speedLabel.text = "Speed"
                speedLabel.font = .systemFont(ofSize: 20, weight: .semibold)
                cell.addSubview(speedLabel)
                speedLabel.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview()
                }
                speedPageControl.numberOfPages = viewModel.returnSpeedArrCount()
                
                cell.addSubview(speedCollection!)
                speedCollection?.snp.makeConstraints({ make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(speedLabel.snp.bottom).inset(-15)
                    make.bottom.equalToSuperview().inset(44)
                })
                
                cell.addSubview(speedPageControl)
                speedPageControl.snp.makeConstraints { make in
                    make.width.equalTo(142)
                    make.top.equalTo(speedCollection!.snp.bottom).inset(-10)
                    make.height.equalTo(24)
                    make.centerX.equalToSuperview()
                }
            } else {
                let speedLabel = UILabel()
                speedLabel.textColor = .black
                speedLabel.text = "Tricks"
                speedLabel.font = .systemFont(ofSize: 20, weight: .semibold)
                cell.addSubview(speedLabel)
                speedLabel.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview()
                }
                tricksPageControl.numberOfPages = viewModel.returnTricksArrCount()
                
                cell.addSubview(tricksCollection!)
                tricksCollection?.snp.makeConstraints({ make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(speedLabel.snp.bottom).inset(-15)
                    make.bottom.equalToSuperview().inset(44)
                })
                cell.addSubview(tricksPageControl)
                tricksPageControl.snp.makeConstraints { make in
                    make.width.equalTo(142)
                    make.top.equalTo(tricksCollection!.snp.bottom).inset(-10)
                    make.height.equalTo(24)
                    make.centerX.equalToSuperview()
                }
            }
            
            return cell
        } else if collectionView == speedCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            if viewModel.returnSpeedArrCount() > 0 {
                
                let mainView = UIView()
                mainView.backgroundColor = .white
                mainView.layer.cornerRadius = 9
                mainView.layer.shadowColor = UIColor.black.cgColor
                mainView.layer.shadowOpacity = 0.25
                mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
                mainView.layer.shadowRadius = 4
                mainView.layer.masksToBounds = false
                
                cell.addSubview(mainView)
                mainView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.bottom.equalToSuperview().inset(5)
                }
                
                let stackView = UIStackView()
                stackView.axis = .vertical
                stackView.backgroundColor = .white
                stackView.distribution = .fillEqually
                mainView.addSubview(stackView)
                stackView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(10)
                    make.top.equalToSuperview().inset(10)
                    make.bottom.equalToSuperview().inset(50)
                }
                
                let distanceView = createLinsesView(textOne: "Distance", textTwo: viewModel.speedArr[indexPath.row].distance + " m")
                let speedView = createLinsesView(textOne: "Speed", textTwo: viewModel.speedArr[indexPath.row].speed + " m/s")
                let timeView = createLinsesView(textOne: "Time", textTwo: viewModel.speedArr[indexPath.row].speed + " s")
                let windView = createLinsesView(textOne: "Wind", textTwo: viewModel.speedArr[indexPath.row].wind + " m/s")
                stackView.addArrangedSubview(distanceView)
                stackView.addArrangedSubview(speedView)
                stackView.addArrangedSubview(timeView)
                stackView.addArrangedSubview(windView)
                
                let dateButton = UIButton()
                dateButton.isEnabled = false
                dateButton.layer.cornerRadius = 6
                dateButton.layer.borderWidth = 0.33
                dateButton.layer.borderColor = UIColor.customBlue.cgColor
                dateButton.setTitleColor(.customBlue, for: .normal)
                dateButton.backgroundColor = .white
                dateButton.setTitle(viewModel.speedArr[indexPath.row].date, for: .normal)
                mainView.addSubview(dateButton)
                dateButton.snp.makeConstraints { make in
                    make.left.equalToSuperview().inset(10)
                    make.top.equalTo(stackView.snp.bottom).inset(-10)
                    make.bottom.equalToSuperview().inset(10)
                    make.right.equalToSuperview().inset(55)
                }
                
                let menuButton = UIButton(type: .system)
                menuButton.tag = indexPath.row
                menuButton.setBackgroundImage(.buttonMenu.resize(targetSize: CGSize(width: 10, height: 10)), for: .normal)
                mainView.addSubview(menuButton)
                menuButton.snp.makeConstraints { make in
                    make.centerY.equalTo(dateButton)
                    make.height.width.equalTo(22)
                    make.right.equalToSuperview().inset(22)
                }
                menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
                
            } else {
                let mainView = EmptySwim(item: "swim")
                cell.addSubview(mainView)
                mainView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.bottom.equalToSuperview().inset(2)
                }
            }
            return cell
        } else if collectionView == tricksCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "3", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            if viewModel.returnTricksArrCount() > 0 {
                
            } else {
                let mainView = EmptySwim(item: "tricks")
                cell.addSubview(mainView)
                mainView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.bottom.equalToSuperview().inset(2)
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollection {
            if indexPath.row == 0 {
                if viewModel.returnSpeedArrCount() > 0 {
                    return CGSize(width: collectionView.bounds.width, height: 280)
                } else {
                    return CGSize(width: collectionView.bounds.width, height: 230)
                }
            } else {
                if viewModel.returnTricksArrCount() > 0 {
                    return CGSize(width: collectionView.bounds.width, height: 370)
                } else {
                    return CGSize(width: collectionView.bounds.width, height: 230)
                }
            }
            
        } else if collectionView == speedCollection {
            if viewModel.returnSpeedArrCount() > 0 {
                return CGSize(width: collectionView.bounds.width, height: 196)
            } else {
                return CGSize(width: collectionView.bounds.width, height: 130)
            }
        } else {
            if viewModel.returnTricksArrCount() > 0 {
                return CGSize(width: collectionView.bounds.width , height: 340)
            } else {
                return CGSize(width: collectionView.bounds.width , height: 130)
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == speedCollection {
            let pageWidth = scrollView.frame.width // Добавьте отступы, если они есть (например, 30 пикселей)
            let pageIndex = round(scrollView.contentOffset.x / pageWidth)
            speedPageControl.currentPage = Int(pageIndex)
        } else if scrollView == tricksCollection {
            let pageWidth = scrollView.frame.width// Аналогично для другой коллекции
            let pageIndex = round(scrollView.contentOffset.x / pageWidth)
            tricksPageControl.currentPage = Int(pageIndex)
        }
    }
    
    
    
}
