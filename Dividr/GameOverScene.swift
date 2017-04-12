//
//  GameOverScene.swift
//  Dividr
//
//  Created by Luke Dinh on 4/8/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.black
        self.anchorPoint.x = 0.5
        self.anchorPoint.y = 0.5
        gameOverInfo()
    }
    func gameOverInfo() {
        let message = "GAME OVER"
        let label = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        label.text = message
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 0, y: 0)
        addChild(label)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 0.3)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
}
