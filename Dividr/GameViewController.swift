//
//  GameViewController.swift
//  Dividr
//
//  Created by Luke Dinh on 4/8/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

var useSound:Bool!

var backgroundMusicPlayer:AVAudioPlayer!

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgMusicURL = Bundle.main.url(forResource: "bgMusic", withExtension: "mp3")!
        do {
            try backgroundMusicPlayer = AVAudioPlayer(contentsOf: bgMusicURL)
        } catch {
            // Handle error
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'StartScreenScene.sks'
            if let scene = SKScene(fileNamed: "StartScreenScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
