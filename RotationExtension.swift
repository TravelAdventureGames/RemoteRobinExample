//
//  RotationExtension.swift
//  RobinPrototype
//
//  Created by Martijn van Gogh on 01-07-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var shouldAutorotate : Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations)!
    }
}
