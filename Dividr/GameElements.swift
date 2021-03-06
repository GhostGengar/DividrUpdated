//
//  GameElements.swift
//  Dividr
//
//  Created by Luke Dinh on 4/8/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import SpriteKit

struct CollisionBitmask {
    static let Player:UInt32 = 0x00
    static let Obstacle:UInt32 = 0x01
    static let ScoringPoint:UInt32 = 0x02
    static let CheckPoint:UInt32 = 0x03
}

enum ObstacleType:Int {
    case Small = 0
    case Medium = 1
    case Large = 2
}

enum RowType:Int {
    case OneS = 0
    case OneM = 1
    case OneL = 2
    case TwoS = 3
    case TwoM = 4
    case ThreeS = 5
}

extension GameScene {
    
    func setUpBgEffect() {
        backgroundEffect = SKEmitterNode(fileNamed: "bgEffect")
        backgroundEffect.position = CGPoint(x: 0, y: 0)
        backgroundEffect.zPosition = -1
        backgroundEffect.advanceSimulationTime(5)
        addChild(backgroundEffect)
    }
    
    func setUpLabels() {
        scoreLabel.fontSize = 100
        scoreLabel.zPosition = 3
        scoreLabel.fontColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        scoreLabel.position = CGPoint(x: 0, y: self.size.height / 2 - 150)
        scoreLabel.text = "0"
        addChild(scoreLabel)
    }
    
    func setUpTailEffects() {
        playerOneTailEffect = SKEmitterNode(fileNamed: "tailEffect")
        playerTwoTailEffect = SKEmitterNode(fileNamed: "tailEffect")
        playerOneTailEffect.targetNode = self
        playerTwoTailEffect.targetNode = self
        playerOneTailEffect.position = CGPoint(x: 0, y: 0)
        playerTwoTailEffect.position = CGPoint(x: 0, y: 0)
    }
    
    func addPlayer() {
        setUpTailEffects()
        
        let playerTexture = SKTexture(imageNamed: "player")
        
        player = SKSpriteNode(texture: playerTexture, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: 0, y: -550)
        player.name = "PLAYER"
        player.physicsBody?.isDynamic = false
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.addChild(playerOneTailEffect)
        player.physicsBody?.categoryBitMask = CollisionBitmask.Player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionBitmask.ScoringPoint | CollisionBitmask.Obstacle
        
        player2 = SKSpriteNode(texture: playerTexture, size: CGSize(width: 50, height: 50))
        player2.position = CGPoint(x: 0, y: -550)
        player2.name = "PLAYER"
        player2.physicsBody?.isDynamic = false
        player2.physicsBody = SKPhysicsBody(rectangleOf: player2.size)
        player2.addChild(playerTwoTailEffect)
        player2.physicsBody?.categoryBitMask = CollisionBitmask.Player
        player2.physicsBody?.collisionBitMask = 0
        player2.physicsBody?.contactTestBitMask = CollisionBitmask.ScoringPoint | CollisionBitmask.Obstacle
        
        addChild(player)
        addChild(player2)
        
        initialPlayerPosition = player.position
        
        if selectedDifficulty == .insane {
            checkPointNode = SKNode()
            checkPointNode.name = "CHECKPOINT"
            checkPointNode.position = CGPoint(x: 0, y: -600)
            checkPointNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 30))
            checkPointNode.physicsBody?.isDynamic = false
            checkPointNode.physicsBody?.categoryBitMask = CollisionBitmask.CheckPoint
            checkPointNode.physicsBody?.collisionBitMask = 0
            checkPointNode.physicsBody?.contactTestBitMask = CollisionBitmask.ScoringPoint
            addChild(checkPointNode)
        }
    }
    
    func addObstacle(type: ObstacleType) -> SKSpriteNode {
        let obstacle = SKSpriteNode(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), size: CGSize(width: 0, height: 30))
        obstacle.name = "OBSTACLE"
        obstacle.physicsBody?.isDynamic = true
        switch type {
        case .Small:
            obstacle.size.width = self.size.width * 0.2
            break
        case .Medium:
            obstacle.size.width = self.size.width * 0.35
            break
        case .Large:
            obstacle.size.width = self.size.width * 0.75
            break
        }
        obstacle.position = CGPoint(x: 0, y: self.size.height / 2 + obstacle.size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.categoryBitMask = CollisionBitmask.Obstacle
        obstacle.physicsBody?.collisionBitMask = 0
        obstacle.physicsBody?.contactTestBitMask = CollisionBitmask.Player

        return obstacle
    }
    
    func addScoringPoint() -> SKSpriteNode {
        let scoringPoint = SKSpriteNode(imageNamed: "scoringNode")
        scoringPoint.name = "SCORING-POINT"
        scoringPoint.position = CGPoint(x: 0, y: self.size.height / 2 + scoringPoint.size.height)
        scoringPoint.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        scoringPoint.physicsBody?.usesPreciseCollisionDetection = true
        scoringPoint.physicsBody?.isDynamic = true
        scoringPoint.physicsBody?.categoryBitMask = CollisionBitmask.ScoringPoint
        scoringPoint.physicsBody?.collisionBitMask = 0
        scoringPoint.physicsBody?.contactTestBitMask = CollisionBitmask.Player
        return scoringPoint
    }
    
    func addRow(type:RowType) {
        switch type {
        case .OneS:
            let obstacle = addObstacle(type: .Small)
            obstacle.position = CGPoint(x: 0, y: obstacle.position.y)
            addMovement(obstacle: obstacle)
            addChild(obstacle)
            
            let scoringPointOne = addScoringPoint()
            let scoringPointTwo = addScoringPoint()
            scoringPointOne.position.x = -obstacle.size.width / 2 - 70
            scoringPointTwo.position.x = obstacle.size.width / 2 + 70
            addMovement(obstacle: scoringPointOne)
            addMovement(obstacle: scoringPointTwo)
            addChild(scoringPointOne)
            addChild(scoringPointTwo)
            break
        case .OneM:
            let obstacle = addObstacle(type: .Medium)
            obstacle.position = CGPoint(x: 0, y: obstacle.position.y)
            addMovement(obstacle: obstacle)
            addChild(obstacle)
            
            let scoringPointOne = addScoringPoint()
            let scoringPointTwo = addScoringPoint()
            scoringPointOne.position.x = -obstacle.size.width / 2 - 70
            scoringPointTwo.position.x = obstacle.size.width / 2 + 70
            addMovement(obstacle: scoringPointOne)
            addMovement(obstacle: scoringPointTwo)
            addChild(scoringPointOne)
            addChild(scoringPointTwo)
            break
        case .OneL:
            let obstacle = addObstacle(type: .Large)
            obstacle.position = CGPoint(x: 0, y: obstacle.position.y)
            addMovement(obstacle: obstacle)
            addChild(obstacle)
            
            let scoringPointOne = addScoringPoint()
            let scoringPointTwo = addScoringPoint()
            scoringPointOne.position.x = -obstacle.size.width / 2 - 70
            scoringPointTwo.position.x = obstacle.size.width / 2 + 70
            addMovement(obstacle: scoringPointOne)
            addMovement(obstacle: scoringPointTwo)
            addChild(scoringPointOne)
            addChild(scoringPointTwo)
            break
        case .TwoS:
            let obstacleOne = addObstacle(type: .Small)
            let obstacleTwo = addObstacle(type: .Small)
            obstacleOne.position = CGPoint(x: -self.size.width / 4, y: obstacleOne.position.y)
            obstacleTwo.position = CGPoint(x: self.size.width / 4, y: obstacleTwo.position.y)
            addMovement(obstacle: obstacleOne)
            addMovement(obstacle: obstacleTwo)
            addChild(obstacleOne)
            addChild(obstacleTwo)
            
            let scoringPointOne = addScoringPoint()
            let scoringPointTwo = addScoringPoint()
            scoringPointOne.position.x = -self.size.width / 4 + obstacleOne.size.width / 2 + 50
            scoringPointTwo.position.x = self.size.width / 4 - obstacleTwo.size.width / 2 - 50
            addMovement(obstacle: scoringPointOne)
            addMovement(obstacle: scoringPointTwo)
            addChild(scoringPointOne)
            addChild(scoringPointTwo)
            break
        case .TwoM:
            let obstacleOne = addObstacle(type: .Medium)
            let obstacleTwo = addObstacle(type: .Medium)
            obstacleOne.position = CGPoint(x: -self.size.width / 4, y: obstacleOne.position.y)
            obstacleTwo.position = CGPoint(x: self.size.width / 4, y: obstacleTwo.position.y)
            addMovement(obstacle: obstacleOne)
            addMovement(obstacle: obstacleTwo)
            addChild(obstacleOne)
            addChild(obstacleTwo)
            
            let scoringPoint = addScoringPoint()
            scoringPoint.position.x = 0
            addMovement(obstacle: scoringPoint)
            addChild(scoringPoint)
            break
        case .ThreeS:
            let obstacleOne = addObstacle(type: .Small)
            let obstacleTwo = addObstacle(type: .Small)
            let obstacleThree = addObstacle(type: .Small)
            obstacleOne.position = CGPoint(x: -self.size.width / 2 + obstacleOne.size.width / 2 + 40, y: obstacleOne.position.y)
            obstacleTwo.position = CGPoint(x: 0, y: obstacleTwo.position.y)
            obstacleThree.position = CGPoint(x: self.size.width / 2 - obstacleThree.size.width / 2 - 40, y: obstacleThree.position.y)
            addMovement(obstacle: obstacleOne)
            addMovement(obstacle: obstacleTwo)
            addMovement(obstacle: obstacleThree)
            addChild(obstacleOne)
            addChild(obstacleTwo)
            addChild(obstacleThree)
            
            let scoringPointOne = addScoringPoint()
            let scoringPointTwo = addScoringPoint()
            scoringPointOne.position.x = -obstacleTwo.size.width / 2 - 70
            scoringPointTwo.position.x = obstacleTwo.size.width / 2 + 70
            addMovement(obstacle: scoringPointOne)
            addMovement(obstacle: scoringPointTwo)
            addChild(scoringPointOne)
            addChild(scoringPointTwo)
            break
        }
    }
    
    func addMovement(obstacle:SKSpriteNode) {
        var actionArray = [SKAction]()
        if selectedDifficulty == .normal || selectedDifficulty == .insane {
            actionArray.append(SKAction.moveTo(y: -obstacle.position.y, duration: 3.3))
        } else {
            actionArray.append(SKAction.moveTo(y: -obstacle.position.y, duration: 2.3))
        }
        actionArray.append(SKAction.removeFromParent())
        obstacle.run(SKAction.sequence(actionArray))
    }

}
