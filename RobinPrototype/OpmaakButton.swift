//
//  OpmaakButton.swift
//  RobinPrototype
//
//  Created by Martijn van Gogh on 30-06-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

class opmaakButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setButtonStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        setButtonStyle()
    }
    
    func setButtonStyle() {
        
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor(red: 80/255, green: 200/255, blue: 230/255, alpha: 1.0)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.titleLabel!.font = UIFont(name: "MarkerFelt-Wide", size: 17)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
    }
}
