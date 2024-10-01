//
//  ViewModelOnbUser.swift
//  WinSerf
//
//  Created by Владимир Кацап on 01.10.2024.
//

import Foundation
import UIKit

class UserOnboardingViewModel {
    private lazy var numberTaps = -1
    private lazy var contentArray: [(UIImage, String)] = [(UIImage.tap1 , "Create groups with co-workers"),
                                                          (UIImage.tap2, "Link them to a project and track their progress"),
                                                          (UIImage.tap3, "Your deadlines will not be missed")]
    
    func tapNextButton() -> (UIImage, String) {
        numberTaps += 1
        return numberTaps <= 2 ? contentArray[numberTaps] : (UIImage(), "")
    }
    
    func checkNextVC() -> Bool {
        return numberTaps == 2 ? true : false
    }
   
}
