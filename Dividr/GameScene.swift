//
//  GameScene.swift
//  Dividr
//
//  Created by Luke Dinh on 4/8/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundEffect:SKEmitterNode!
    
    var player:SKSpriteNode!
    var player2:SKSpriteNode!
    
    var initialPlayerPosition:CGPoint!
    
    let scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    var score:Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let maximumPossibleForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = force/maximumPossibleForce
            player.position.x = -normalizedForce * (self.size.width / 2 - 25)
            player2.position.x = normalizedForce * (self.size.width / 2 - 25)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPlayerPosition()
    }
    
    func resetPlayerPosition() {
        player.position = initialPlayerPosition
        player2.position = initialPlayerPosition
    }

    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        self.anchorPoint.x = 0.5
        self.anchorPoint.y = 0.5
        addPlayer()
        setUpLabels()
        setUpBgEffect()
    }
    
    func randomRow() {
        let randomNumber = Int(arc4random_uniform(6))
        switch randomNumber {
        case 0:
            addRow(type: RowType(rawValue: 0)!)
            break
        case 1:
            addRow(type: RowType(rawValue: 1)!)
            break
        case 2:
            addRow(type: RowType(rawValue: 2)!)
            break
        case 3:
            addRow(type: RowType(rawValue: 3)!)
            break
        case 4:
            addRow(type: RowType(rawValue: 4)!)
            break
        case 5:
            addRow(type: RowType(rawValue: 5)!)
            break
        default:
            break
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var scoringPoint:SKSpriteNode!
        if (contact.bodyA.node?.name == "PLAYER" && contact.bodyB.node?.name == "OBSTACLE") || (contact.bodyA.node?.name == "OBSTACLE" && contact.bodyB.node?.name == "PLAYER") {
            showGameOver()
        } else if (contact.bodyA.node?.name == "PLAYER" && contact.bodyB.node?.name == "SCORING-POINT") || (contact.bodyA.node?.name == "SCORING-POINT" && contact.bodyB.node?.name == "PLAYER") {
            if contact.bodyA.node?.name == "SCORING-POINT" {
                scoringPoint = contact.bodyA.node as! SKSpriteNode
                self.run(SKAction.playSoundFileNamed("scored.mp3", waitForCompletion: false))
                self.playerDidScore(whatScoringNode: scoringPoint)
            } else {
                scoringPoint = contact.bodyB.node as! SKSpriteNode
                self.run(SKAction.playSoundFileNamed("scored.mp3", waitForCompletion: false))
                self.playerDidScore(whatScoringNode: scoringPoint)
            }
        }
    }
    
    func showGameOver() {
        let transition = SKTransition.fade(withDuration: 0.2)
        let gameOverScene = GameOverScene(size: self.size)
        self.removeAllChildren()
        self.view?.presentScene(gameOverScene, transition: transition)
        updateHighScore(withScore: score)
    }
    
    func playerDidScore(whatScoringNode: SKSpriteNode) {
        whatScoringNode.removeFromParent()
        score += 1
    }
    
    func updateHighScore(withScore:Int) {
        let userDefaults = UserDefaults.standard
        if let currentHighestScore = userDefaults.value(forKey: "HIGHEST-SCORE") as? Int {
            if withScore > currentHighestScore {
                userDefaults.set(withScore, forKey: "HIGHEST-SCORE")
                userDefaults.synchronize()
            }
        } else {
            userDefaults.set(withScore, forKey: "HIGHEST-SCORE")
            userDefaults.synchronize()
        }
    }
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeInterval = TimeInterval()
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate:TimeInterval) {
        lastYieldTimeInterval += timeSinceLastUpdate
        if lastYieldTimeInterval > 0.6 {
            lastYieldTimeInterval = 0
            randomRow()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered.
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate: timeSinceLastUpdate)
    }
}
