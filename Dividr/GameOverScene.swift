//
//  GameOverScene.swift
//  Dividr
//
//  Created by Luke Dinh on 4/14/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var lastGameScoreLabelNode:SKLabelNode!
    var currentHighScoreLabelNode:SKLabelNode!
    
    var replayButtonNode:SKSpriteNode!
    var mainMenuButtonNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUpLabels()
        setUpButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "replayButton" {
                replayAction()
            } else if nodesArray.first?.name == "mainMenuButton" {
                mainMenuAction()
            }
        }
    }
    
    func replayAction() {
        let transition = SKTransition.fade(withDuration: 0.3)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func mainMenuAction() {
        let transition = SKTransition.fade(withDuration: 0.3)
        if let startScreenScene = SKScene(fileNamed: "StartScreenScene") {
            startScreenScene.scaleMode = .aspectFill
            self.view?.presentScene(startScreenScene, transition: transition)
        }
    }
    
    func setUpLabels() {
        lastGameScoreLabelNode = self.childNode(withName: "lastGameScoreLabel") as! SKLabelNode
        lastGameScoreLabelNode.text = "Score: \(globalCurrentScore)"
        currentHighScoreLabelNode = self.childNode(withName: "currentHighScoreLabel") as! SKLabelNode
        let userDefaults = UserDefaults.standard
        var currentDifficultyText:String!
        if selectedDifficulty == .normal {
            currentDifficultyText = "NORMAL-HIGHEST-SCORE"
        } else if selectedDifficulty == .hard {
            currentDifficultyText = "HARD-HIGHEST-SCORE"
        } else {
            currentDifficultyText = "INSANE-HIGHEST-SCORE"
        }
        if let score = userDefaults.value(forKey: currentDifficultyText) as? Int {
            if globalCurrentScore > score {
                updateHighScore(withScore: globalCurrentScore)
                currentHighScoreLabelNode.text = "New Best Score!"
            } else {
                currentHighScoreLabelNode.text = "High Score: \(score)"
            }
        } else {
            updateHighScore(withScore: globalCurrentScore)
            currentHighScoreLabelNode.text = "New Best Score!"
        }
    }
    
    func setUpButtons() {
        replayButtonNode = self.childNode(withName: "replayButton") as! SKSpriteNode
        mainMenuButtonNode = self.childNode(withName: "mainMenuButton") as! SKSpriteNode
    }
    
    func updateHighScore(withScore:Int) {
        let userDefaults = UserDefaults.standard
        var currentDifficultyText:String!
        if selectedDifficulty == .normal {
            currentDifficultyText = "NORMAL-HIGHEST-SCORE"
        } else if selectedDifficulty == .hard {
            currentDifficultyText = "HARD-HIGHEST-SCORE"
        } else {
            currentDifficultyText = "INSANE-HIGHEST-SCORE"
        }
        if let currentHighestScore = userDefaults.value(forKey: currentDifficultyText) as? Int {
            if withScore > currentHighestScore {
                userDefaults.set(withScore, forKey: currentDifficultyText)
                userDefaults.synchronize()
            }
        } else {
            userDefaults.set(withScore, forKey: currentDifficultyText)
            userDefaults.synchronize()
        }
    }
}
