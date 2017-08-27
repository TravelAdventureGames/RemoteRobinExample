//
//  VideoVC.swift
//  RobinPrototype
//
//  Created by Martijn van Gogh on 01-07-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit
import SceneKit
import CoreMotion
import SpriteKit
import AVFoundation

class VideoVC: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet var sceneView: SCNView!
    
    var player: AVAudioPlayer = AVAudioPlayer()
    var vplayer: AVPlayer = AVPlayer()
    var motionManager = CMMotionManager()
    let cameraNode = SCNNode()
    var myPlayer = PlaySound()
    var tambCounter = 0
    var timesTambed: Int = 0 {
        didSet {
            print("\(timesTambed) times tambed!")
        }
    }
    var playing = false
    
    
    override func viewDidLoad() {
        //LOOPCODE
        /*NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(VideoVC.playerItemDidReachEnd(_:)),name: AVPlayerItemDidPlayToEndTimeNotification,object: self.vplayer.currentItem)*/
        
        startCameraTracking()
        
        self.navigationController?.isNavigationBarHidden = true
        
        do {
            try playVideo()
        } catch AppError.invalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
        
    }
    
    func playTamborine() {
        
        switch tambCounter {
        case 0:
            myPlayer.playIt2()
            tambCounter += 1
        case 1:
            myPlayer.playIt1()
            tambCounter = 0
            
        default:
            break
        }
        
    }

    func createSphereNode(material: AnyObject?) -> SCNNode {
        let sphere = SCNSphere(radius: 20.0)
        sphere.firstMaterial!.isDoubleSided = true
        sphere.firstMaterial!.diffuse.contents = material
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3Make(0,0,0)
        return sphereNode
    }
    
    func configureScene(node sphereNode: SCNNode) {
        // Set the scene
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.showsStatistics = false
        sceneView.allowsCameraControl = false
        // Camera, ...
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 0)
        scene.rootNode.addChildNode(sphereNode)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func startCameraTracking() {
        motionManager.deviceMotionUpdateInterval = 0.06
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler:{
            deviceManager, error in
            guard let data = deviceManager else { return }
            
            let attitude: CMAttitude = data.attitude
            self.cameraNode.eulerAngles = SCNVector3Make(Float(attitude.roll + M_PI/2.0), -Float(attitude.yaw), -Float(attitude.pitch))
            
            let accelartion = data.userAcceleration
            let xmovement = accelartion.x
            switch (xmovement > 0.6, xmovement < -1.2) {
            case (true, false):
                self.playTamborine()
                print("it was \(xmovement)!")
                
                if !self.playing {
                    self.timesTambed += 1
                    switch self.timesTambed {
                    case 3:
                        self.playMe(file: "Zin1", ext: "wav")
                        self.playing = true
                    case 4:
                        self.playMe(file: "Zin3", ext: "wav")
                        self.playing = true
                    case 5:
                        self.playMe(file: "Zin4", ext: "wav")
                        self.myPlayer.playForever()
                        self.playing = true
                    case 40:
                        self.playMe(file: "Zin6", ext: "wav")
                        self.playing = true
                    case 50:
                        self.playMe(file: "Zin7", ext: "wav")
                        self.playing = true
                    case 60:
                        self.myPlayer.playerContinously.stop()
                        self.playMe(file: "Zin5", ext: "wav")
                        
                    default:
                        break
                        
                    }
                }
                
            default:
                break
            }
            
        })
        
    }


    override func viewWillDisappear(_ animated: Bool) {
        motionManager.stopDeviceMotionUpdates()
        //NSNotificationCenter.defaultCenter().removeObserver(AVPlayerItemDidPlayToEndTimeNotification)
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("it finished")
        playing = false
        
        if timesTambed > 59 {
            vplayer.rate = 0.0
            print("it al finished")
            performSegue(withIdentifier: "naar map", sender: self)
        }
    }

    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }

    
    fileprivate func playVideo() throws {
        
        guard let path = Bundle.main.path(forResource: "robinFilm", ofType:"m4v") else {
            throw AppError.invalidResource("robinFilm", "m4v")
        }
        vplayer = AVPlayer(url: URL(fileURLWithPath: path))
        let videoNode = SKVideoNode(avPlayer: vplayer)
        let size = CGSize(width: 1024,height: 512)
        videoNode.size = size
        videoNode.position = CGPoint(x: size.width/2.0,y: size.height/2.0)
        let spriteScene = SKScene(size: size)
        spriteScene.addChild(videoNode)
        
        let sphereNode = createSphereNode(material:spriteScene)
        configureScene(node: sphereNode)
        guard motionManager.isDeviceMotionAvailable else {
            fatalError("Device motion is not available")
        }
        
        
    }
    //LOOPCODE: acts upon notification and loops the video
    /*func playerItemDidReachEnd(notification: NSNotification) {
        do {
            try playVideo()
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        sceneView.play(self)
    }
    

    
    func playMe(file: String, ext: String) {
        
        let file: URL = Bundle.main.url(forResource: file, withExtension: ext)!
        do { player = try AVAudioPlayer(contentsOf: file, fileTypeHint: nil)
            
        } catch _ {
            return
        }
        player.numberOfLoops = 0
        player.prepareToPlay()
        player.play()
        player.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
enum AppError : Error {
    case invalidResource(String, String)
}
