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
    func addPlayer() {
        player = SKSpriteNode(color: #colorLiteral(red: 1, green: 0.007480408822, blue: 0.0707211995, alpha: 1), size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: 0, y: -550)
        player.name = "PLAYER"
        player.physicsBody?.isDynamic = false
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = CollisionBitmask.Player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionBitmask.Obstacle
        
        player2 = SKSpriteNode(color: #colorLiteral(red: 1, green: 0.007480408822, blue: 0.0707211995, alpha: 1), size: CGSize(width: 50, height: 50))
        player2.position = CGPoint(x: 0, y: -550)
        player2.name = "PLAYER"
        player2.physicsBody?.isDynamic = false
        player2.physicsBody = SKPhysicsBody(rectangleOf: player2.size)
        player2.physicsBody?.categoryBitMask = CollisionBitmask.Player
        player2.physicsBody?.collisionBitMask = 0
        player2.physicsBody?.contactTestBitMask = CollisionBitmask.Obstacle
        
        addChild(player)
        addChild(player2)
        
        initialPlayerPosition = player.position
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

        return obstacle
    }
    
    func addRow(type:RowType) {
        switch type {
        case .OneS:
            let obstacle = addObstacle(type: .Small)
            obstacle.position = CGPoint(x: 0, y: obstacle.position.y)
            addMovement(obstacle: obstacle)
            addChild(obstacle)
            break
        case .OneM:
            let obstacle = addObstacle(type: .Medium)
            obstacle.position = CGPoint(x: 0, y: obstacle.position.y)
            addMovement(obstacle: obstacle)
            addChild(obstacle)
            break
        case .OneL:
            let obstacle = addObstacle(type: .Large)
            obstacle.position = CGPoint(x: 0, y: obstacle.position.y)
            addMovement(obstacle: obstacle)
            addChild(obstacle)
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
            break
        case .ThreeS:
            let obstacleOne = addObstacle(type: .Small)
            let obstacleTwo = addObstacle(type: .Small)
            let obstacleThree = addObstacle(type: .Small)
            obstacleOne.position = CGPoint(x: -400, y: obstacleOne.position.y)
            obstacleTwo.position = CGPoint(x: 0, y: obstacleTwo.position.y)
            obstacleThree.position = CGPoint(x: 400, y: obstacleThree.position.y)
            addMovement(obstacle: obstacleOne)
            addMovement(obstacle: obstacleTwo)
            addMovement(obstacle: obstacleThree)
            addChild(obstacleOne)
            addChild(obstacleTwo)
            addChild(obstacleThree)
            break
        }
    }
    
    func addMovement(obstacle:SKSpriteNode) {
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveTo(y: -obstacle.position.y, duration: 3.3))
        actionArray.append(SKAction.removeFromParent())
        obstacle.run(SKAction.sequence(actionArray))
    }

}
