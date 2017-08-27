//
//  OpmaakLabel.swift
//  RobinPrototype
//
//  Created by Martijn van Gogh on 02-07-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

class OpmaakLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setLabelStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        setLabelStyle()
    }
    
    func setLabelStyle() {
        
        self.layer.cornerRadius = 5
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.3
        self.font = UIFont(name: "Helveticaneue-Bold", size: 12)
        self.textAlignment = .center
        self.layer.masksToBounds = true
        
    }
}
