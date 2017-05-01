//
//  HighScoreScene.swift
//  Dividr
//
//  Created by Luke Dinh on 4/18/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import SpriteKit

class HighScoreScene: SKScene {
    
    var normalHighScoreNode:SKLabelNode!
    var hardHighScoreNode:SKLabelNode!
    var insaneHighScoreNode:SKLabelNode!
    
    var mainMenuButtonNode:SKSpriteNode!
    
    func setUpLabels() {
        let userDefaults = UserDefaults.standard
        normalHighScoreNode = self.childNode(withName: "normalHighScore") as! SKLabelNode
        hardHighScoreNode = self.childNode(withName: "hardHighScore") as! SKLabelNode
        insaneHighScoreNode = self.childNode(withName: "insaneHighScore") as! SKLabelNode
        
        if let normalHighestScore = userDefaults.value(forKey: "NORMAL-HIGHEST-SCORE") as? Int {
            normalHighScoreNode.text = "Normal: \(normalHighestScore)"
        }
        
        if let hardHighestScore = userDefaults.value(forKey: "HARD-HIGHEST-SCORE") as? Int {
            hardHighScoreNode.text = "Hard: \(hardHighestScore)"
        }
        
        if let insaneHighestScore = userDefaults.value(forKey: "INSANE-HIGHEST-SCORE") as? Int {
            insaneHighScoreNode.text = "Insane: \(insaneHighestScore)"
        }
        
    }
    
    func setUpButtons() {
        mainMenuButtonNode = self.childNode(withName: "mainMenuButton") as! SKSpriteNode
    }
    
    func mainMenu() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let mainMenuScene = SKScene(fileNamed: "StartScreenScene")!
        mainMenuScene.scaleMode = .aspectFill
        self.view?.presentScene(mainMenuScene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "mainMenuButton" {
                self.mainMenu()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUpLabels()
        setUpButtons()
    }
    
}
