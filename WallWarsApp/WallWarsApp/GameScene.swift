//
//  GameScene.swift
//  WallWarsApp
//
//  Created by Stefano  on 04/07/22.
//

import Foundation
import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate{
    
    
    
    var lifePoints:Int = 0
    

    
    let backround = SKSpriteNode(imageNamed: "background")
    let paddel = SKSpriteNode(imageNamed: "satellite")
    let ball = SKSpriteNode(imageNamed: "yellowbomb")

    
    //theese values are used to keep track on the relation between the objects collisions
    //and relative bitmasks
    enum bitmasks:UInt32 {
        //1
        case frame = 0b1
        //2
        case paddel = 0b10
        //4
        case stone = 0b100
        //8
        case ball = 0b1000
        
    }
    
    
    override func didMove(to view: SKView) {
        //scene customization
        scene?.size =  view .bounds.size
        scene?.scaleMode = .aspectFill
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        //to set the start/pause bool
        self.isPaused = true
        

        
        
        //this set the backround position and size
        backround.position = CGPoint(x: size.width/2, y: size.height/2)
        backround.zPosition = 1
        backround.setScale(1)
        addChild(backround)
        backgroundColor = .blue
        
        
        //paddel/satellite position and size
        paddel.setScale(0.4)
        paddel.position = CGPoint(x: size.width/2, y: 25)
        paddel.zPosition = 10
        //giving the same size as self to skphysicsbody
        paddel.physicsBody = SKPhysicsBody (circleOfRadius: 20)
        //physics on other objects
        paddel.physicsBody?.friction = 0
        paddel.physicsBody?.allowsRotation = false
        paddel.physicsBody?.restitution = 1.030
        paddel.physicsBody?.isDynamic = false
        paddel.physicsBody?.categoryBitMask = bitmasks.paddel.rawValue
        paddel.physicsBody?.contactTestBitMask = bitmasks.ball.rawValue
        paddel.physicsBody?.collisionBitMask = bitmasks.ball.rawValue
        addChild(paddel)
        
        //ball/bomb position and size
        ball.setScale(0.15)
        ball.position.x = paddel.position.x
        ball.position.y = paddel.position.y + ball.size.height
        ball.zPosition = 10
      
        //physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.allowsRotation = false //try with true
        //physics on other objects
        ball.physicsBody?.categoryBitMask = bitmasks.ball.rawValue
        ball.physicsBody?.contactTestBitMask = bitmasks.paddel.rawValue | bitmasks.frame.rawValue  |  bitmasks.stone.rawValue
        ball.physicsBody?.collisionBitMask  = bitmasks.paddel.rawValue | bitmasks.frame.rawValue  |  bitmasks.stone.rawValue
        addChild(ball)
        
        //to make ball move while gravity is 0 (velocity)
        ball.physicsBody?.applyImpulse(CGVector(dx: 50, dy: -50) )
        
        //frame of the game
        
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
        //physics
        frame.friction = 0
        frame.categoryBitMask = bitmasks.frame.rawValue
        frame.contactTestBitMask = bitmasks.ball.rawValue
        frame.collisionBitMask = bitmasks.ball.rawValue
        self.physicsBody = frame
        
     
        
        //Enemies
        
        makeStones(rFactor: 6, bitmask: 0b100, y: 800, imageName: "spaceship1")
        makeStones(rFactor: 6, bitmask: 0b100, y: 750, imageName: "spaceship3")
        makeStones(rFactor: 6, bitmask: 0b100, y: 700, imageName: "spaceship5")
        makeStones(rFactor: 6, bitmask: 0b100, y: 650, imageName: "spaceship4")
        makeStones(rFactor: 6, bitmask: 0b100, y: 600, imageName: "spaceship2")

            
        
    }
    
    
    //func to build the enemies
    // r: reihe
    func makeStones(rFactor:Int , bitmask:UInt32 , y : Int ,imageName:String){
        
        for i in 1...rFactor{
            
            let stone = SKSpriteNode(imageNamed: imageName)
            
            //this create a loop and increases the position
            stone.setScale(0.105)
            stone.position = (CGPoint(x: -30 + i * Int(stone.size.width), y: y))
            stone.zPosition = 10
            stone.name = "Stone" + String(i)
            //physic on area equal to the stone size
            stone.physicsBody = SKPhysicsBody(circleOfRadius:  stone.size.height/2)
            //physics on other object
            stone.physicsBody?.friction = 0
            stone.physicsBody?.allowsRotation = false
            //each collision with enemies will increase the speed of the bomb/ball
            stone.physicsBody?.restitution = 1.045
            stone.physicsBody?.isDynamic = false
            stone.physicsBody?.categoryBitMask =  bitmasks.stone.rawValue
            stone.physicsBody?.contactTestBitMask = bitmasks.ball.rawValue
            stone.physicsBody?.collisionBitMask = bitmasks.ball.rawValue
            addChild(stone)
          
            
        }
        
    }
    
    
    
//    func makelifePoints(lifePoints:Int){
//        var i = 0
//
//      while (i <= lifePoints ) {
//
//            let stone = SKSpriteNode(imageNamed: "earth2.png")
//
//            //this create a loop and increases the position
//          stone.setScale(0.4)
//            stone.position = (CGPoint(x: 200, y: 800))
//            stone.zPosition = 10
//            addChild(stone)
//            i += 1
//
//
//
//        }
//
//    }
    
//    func textLifePoints (){
//
//        TextOutputStream(String(lifePoints))
//    }
    
    
    
    
//    func didBegin(_ contact: SKPhysicsContact) {
//        let contactA:SKPhysicsBody
//        let contactB:SKPhysicsBody
//    }
    
    //this enable the touch gesture on paddel/satellite
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let lokation = touch.location(in: self)
            
            paddel.position.x = lokation.x
        }
    }
    
    //to start the game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isPaused = false
    }
    
    
    //set constraint on the satellite movements
    override func update(_ currentTime: TimeInterval) {
        if paddel.position.x < 50 {
            paddel.position.x = 50
        }
        
//        if paddel.position.x > self.size.width / 2 {
//            paddel.position.x = self.size.width / 2
//        }
        
    }
    
    
    
    
    
    
    //reversed physics relation
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA:SKPhysicsBody
        let contactB:SKPhysicsBody
        
        
        //contact cases
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            
            contactA = contact.bodyA
            //ball
            contactB = contact.bodyB
        } else {
            contactA = contact.bodyB
            //ball
            contactB = contact.bodyA
            
        }
        
        if (contactA.categoryBitMask ==  bitmasks.stone.rawValue && contactB.categoryBitMask == bitmasks.ball.rawValue ){
            
            //when contact is with stone  and ball it will delete it
            contactA.node?.removeFromParent()
            
        }
        
        //nested controls
        if contactA.categoryBitMask == bitmasks.paddel.rawValue && contactB.categoryBitMask == bitmasks.ball.rawValue{
            
//            //this add another step of difficulty when happen collision
//            if (contactB.node!.position.x  <= contactA.node!.frame.midX-5) {
//                contactB.node?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//                contactB.node?.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
//
//            }
//            if contactB.node!.position.x >= contactA.node!.frame.midX + 5 {
//
//                contactB.node?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//                contactB.node?.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
//
//            }
            
            
            
            
        }
        
        
        //when game over will recall our spark fx
        
        
        if(contactA.categoryBitMask == bitmasks.frame.rawValue && contactB.categoryBitMask == bitmasks.ball.rawValue){
            
            let yPosition = contact.contactPoint.y
            
            if (yPosition <= self.frame.minY + 10) {
                
                lifePoints += 1
                
                if (lifePoints == 3){
                
                gameOver()
                }
            }
        }
        
        
    }

    
    func gameOver(){
        
        let gameOverScene = GameOverScene(size: self.size)
        let transition = SKTransition.flipVertical(withDuration: 2)
        
        self.view?.presentScene(gameOverScene,transition: transition)
    }
    
    
}




