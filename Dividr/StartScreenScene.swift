//
//  StartScreenScene.swift
//  Dividr
//
//  Created by Luke Dinh on 4/12/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import SpriteKit

class StartScreenScene: SKScene {
    
    var newGameButtonNode:SKSpriteNode!
    var highScoreButtonNode:SKSpriteNode!
    var titleLabelNode:SKLabelNode!
    var highScoreLabelNode:SKLabelNode!
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUpButtons()
        setUpLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "newGameButton" {
                self.newGame()
            } else if nodesArray.first?.name == "highScoreButton" {
                self.showHighScore()
            }
        }
    }
    
    func setUpButtons() {
        newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode
        highScoreButtonNode = self.childNode(withName: "highScoreButton") as! SKSpriteNode
    }
    
    func setUpLabels() {
        titleLabelNode = self.childNode(withName: "titleLabel") as! SKLabelNode
        highScoreLabelNode = self.childNode(withName: "highScoreLabel") as! SKLabelNode
    }
    
    func newGame() {
        let transition = SKTransition.fade(withDuration: 0.7)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func showHighScore() {
        let userDefaults = UserDefaults.standard
        if let score = userDefaults.value(forKey: "HIGHEST-SCORE") as? Int {
            highScoreLabelNode.text = String(score)
        }
    }
}
