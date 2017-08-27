//
//  Helpers.swift
//  RobinPrototype
//
//  Created by Martijn van Gogh on 29-06-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PlaySound {

    
    var player1 = AVAudioPlayer()
    var player2 = AVAudioPlayer()
    var playerContinously = AVAudioPlayer()
    var stemPlayer: AVAudioPlayer?
    
    
    

    func playIt1() {
        
        let sound1 = Bundle.main.url(forResource: "tamb3", withExtension: "wav")!
        
        
        do {
            player1 = try AVAudioPlayer(contentsOf: sound1, fileTypeHint: nil)
        } catch {
            print("Doesn't work, whats wrong?")
        }
        player1.prepareToPlay()
        player1.numberOfLoops = 0
        player1.play()
        print("Played tamb 4")
        
    }
    
    func playIt2() {
        
        let sound1 = Bundle.main.url(forResource: "tamb3", withExtension: "wav")!
        
        
        do {
            player2 = try AVAudioPlayer(contentsOf: sound1, fileTypeHint: nil)
        } catch {
            print("Doesn't work, whats wrong?")
        }
        player2.prepareToPlay()
        player2.numberOfLoops = 0
        player2.play()
        print("Played tamb 3")
        
    }
    
    func playForever() {
        let path = Bundle.main.url(forResource: "amsterdamsegrachten", withExtension: "mp3")!
        
        do {
            playerContinously = try AVAudioPlayer(contentsOf: path, fileTypeHint: nil)
        } catch {
            print("File doesn't exist?")
        }
        playerContinously.prepareToPlay()
        playerContinously.numberOfLoops = -1
        playerContinously.play()
        
        
    }
    
    func playSpecificSound(_ file: String, ext: String) {
        let path = Bundle.main.url(forResource: file, withExtension: ext)!
        
        do {
            playerContinously = try AVAudioPlayer(contentsOf: path, fileTypeHint: nil)
        } catch {
            print("File doesn't exist?")
        }
        playerContinously.prepareToPlay()
        playerContinously.numberOfLoops = 0
        playerContinously.play()
    }
    
}
