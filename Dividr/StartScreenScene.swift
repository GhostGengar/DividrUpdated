//
//  StartScreenScene.swift
//  Dividr
//
//  Created by Luke Dinh on 4/12/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import SpriteKit

enum GameDifficulties:Int {
    case normal = 0
    case hard = 1
    case insane = 2
}

var selectedDifficulty:GameDifficulties!

class StartScreenScene: SKScene {
    
    var newGameButtonNode:SKSpriteNode!
    var highScoreButtonNode:SKSpriteNode!
    var difficultyButtonNode:SKSpriteNode!
    var soundButtonNode:SKSpriteNode!
    var titleLabelNode:SKLabelNode!
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUpButtons()
        setUpLabels()
        loadDifficulty()
        loadSoundMode()
        if useSound {
            backgroundMusicPlayer.play()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "newGameButton" {
                self.newGame()
            } else if nodesArray.first?.name == "highScoreButton" {
                self.showHighScore()
            } else if nodesArray.first?.name == "difficultyButton" {
                self.changeDifficulty()
            } else if nodesArray.first?.name == "soundButton" {
                self.switchSoundMode()
            }
        }
    }
    
    func setUpButtons() {
        newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode
        highScoreButtonNode = self.childNode(withName: "highScoreButton") as! SKSpriteNode
        difficultyButtonNode = self.childNode(withName: "difficultyButton") as! SKSpriteNode
        soundButtonNode = self.childNode(withName: "soundButton") as! SKSpriteNode
    }
    
    func setUpLabels() {
        titleLabelNode = self.childNode(withName: "titleLabel") as! SKLabelNode
    }
    
    func newGame() {
        let transition = SKTransition.fade(withDuration: 0.7)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func showHighScore() {
        let transition = SKTransition.fade(withDuration: 0.3)
        let highScoreScene = SKScene(fileNamed: "HighScoreScene")!
        highScoreScene.scaleMode = .aspectFill
        self.view?.presentScene(highScoreScene, transition: transition)
    }
    
    func changeDifficulty() {
        let userDefaults = UserDefaults.standard
        if selectedDifficulty == .normal {
            selectedDifficulty = .hard
            difficultyButtonNode.texture = SKTexture(imageNamed: "hardMode")
            userDefaults.set(selectedDifficulty.rawValue, forKey: "CURRENT-DIFFICULTY")
        } else if selectedDifficulty == .hard {
            selectedDifficulty = .insane
            difficultyButtonNode.texture = SKTexture(imageNamed: "insaneMode")
            userDefaults.set(selectedDifficulty.rawValue, forKey: "CURRENT-DIFFICULTY")
        } else if selectedDifficulty == .insane {
            selectedDifficulty = .normal
            difficultyButtonNode.texture = SKTexture(imageNamed: "normalMode")
            userDefaults.set(selectedDifficulty.rawValue, forKey: "CURRENT-DIFFICULTY")
        }
        userDefaults.synchronize()
    }
    
    func loadDifficulty() {
        let userDefaults = UserDefaults.standard
        if let rawDifficulty = userDefaults.value(forKey: "CURRENT-DIFFICULTY") as? GameDifficulties.RawValue {
            switch rawDifficulty {
            case 0:
                selectedDifficulty = .normal
                difficultyButtonNode.texture = SKTexture(imageNamed: "normalMode")
                break
            case 1:
                selectedDifficulty = .hard
                difficultyButtonNode.texture = SKTexture(imageNamed: "hardMode")
                break
            case 2:
                selectedDifficulty = .insane
                difficultyButtonNode.texture = SKTexture(imageNamed: "insaneMode")
                break
            default:
                break
            }
        } else {
            selectedDifficulty = .normal
            difficultyButtonNode.texture = SKTexture(imageNamed: "normalMode")
        }
    }
    
    func switchSoundMode() {
        let userDefaults = UserDefaults.standard
        if useSound {
            soundButtonNode.texture = SKTexture(imageNamed: "soundOff")
            useSound = false
            userDefaults.set(false, forKey: "USE-SOUND")
            backgroundMusicPlayer.pause()
        } else {
            soundButtonNode.texture = SKTexture(imageNamed: "soundOn")
            useSound = true
            userDefaults.set(true, forKey: "USE-SOUND")
            backgroundMusicPlayer.play()
        }
        userDefaults.synchronize()
    }
    
    func loadSoundMode() {
        let userDefaults = UserDefaults.standard
        if let currentSoundMode = userDefaults.value(forKey: "USE-SOUND") as? Bool {
            if currentSoundMode {
                soundButtonNode.texture = SKTexture(imageNamed: "soundOn")
                useSound = true
            } else {
                soundButtonNode.texture = SKTexture(imageNamed: "soundOff")
                useSound = false
            }
        } else {
            soundButtonNode.texture = SKTexture(imageNamed: "soundOn")
            useSound = true
        }
    }
    
}
