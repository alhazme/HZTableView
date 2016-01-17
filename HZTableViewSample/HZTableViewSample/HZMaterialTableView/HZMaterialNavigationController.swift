//
//  HZMaterialNavigationController.swift
//  HZMaterialDesign
//
//  Created by Moch Fariz Al Hazmi on 12/31/15.
//  Copyright © 2015 alhazme. All rights reserved.
//

import UIKit
import Foundation

class HZMaterialNavigationController: UINavigationController {
    
    enum NavigationBarVisibility {
        case Hidden
        case Visible
    }
    var visibility : NavigationBarVisibility = .Hidden {
        didSet {
            if visibility == .Visible {
                navigationBar.alpha = 1
            }
            else {
                navigationBar.alpha = 0
            }
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // Init
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    deinit {
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        if visibility == .Hidden {
//            return .Default
//        }
//        else {
            return .LightContent
//        }
    }
    
}