//
//  ConductVC.swift
//  RobinPrototype
//
//  Created by Martijn van Gogh on 29-06-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import AVKit
import CoreMotion

class ConductVC: UIViewController {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    var tambCounter = 0
    var timesTambed: Int = 0 {
        didSet {
            print("\(timesTambed) times tambed!")
        }
    }
    
    var myPlayer = PlaySound()
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeRespond))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "➤", style: .plain, target: self, action: #selector(nextTapped))
        
        imageView.image = UIImage(named: "magerebrug.jpg")
        textView.text = "Gap, je staat bij de magere brug jongen! En wat denk je? Juistem, er ligt hier een opdracht op je te wachten. Wat het is, kan ik je helaas niet precies zeggen, maar ik hoop dat je ritmegevoel een beetje in orde is. Kijk goed om je heen en gebruik je telefoon. Dat aparaatje van je kan meer dan je denkt. Misschien is het zelfs een dirigeerstokje?\n\nGa snel naar de opdracht om dat uit te vinden!"
        title = "MISSIE"
        titleLabel.text = "MAGERE BRUG"
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func swipeRespond(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer  {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                performSegue(withIdentifier: "naar tamboerijn video", sender: self)
            default:
                break
            }
        }
    }

    func nextTapped() {
         self.performSegue(withIdentifier: "naar tamboerijn video", sender: self)
    }

    
}

