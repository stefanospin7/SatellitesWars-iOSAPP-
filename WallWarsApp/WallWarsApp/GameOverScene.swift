//
//  GameOverScene.swift
//  WallWarsApp
//
//  Created by Stefano  on 04/07/22.
//

import Foundation
import SpriteKit

class GameOverScene:SKScene {
    let gameOver = SKSpriteNode(imageNamed: "gameOver")
    
    override func didMove(to view: SKView) {
        backgroundColor = .cyan
        //this way will be at the center on each display
        gameOver.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOver.setScale(0.5)
        gameOver.zPosition = 5
        
        addChild(gameOver)
        
        let spark = SKEmitterNode(fileNamed: "spark")
        spark?.position = CGPoint(x: gameOver.position.x, y: gameOver.position.y - gameOver.size.height / 2)
        spark?.zPosition = 4
        addChild(spark!)
        
    }
}
