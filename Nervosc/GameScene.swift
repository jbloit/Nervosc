//
//  GameScene.swift
//  Nervosc
//
//  Created by julien@macmini on 26/02/16.
//  Copyright (c) 2016 jbloit. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    let nerve = Nerve.sharedInstance()
    let centerStar = SKSpriteNode(imageNamed:"star")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        
        self.backgroundColor = SKColor.blackColor()
        
        physicsWorld.gravity = CGVectorMake(0, -10)

        centerStar.xScale = 1.0
        centerStar.yScale = 1.0
        centerStar.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)!)

        centerStar.physicsBody = SKPhysicsBody(circleOfRadius: centerStar.size.height / 15.0)
        centerStar.physicsBody?.dynamic = false
        
        
        self.addChild(centerStar)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            
            nerve?.sendMessage("-------- TOUCHED NERVE ---------")
            
            let location = touch.locationInNode(self)
            
            let star = SKSpriteNode(imageNamed:"star")
            star.xScale = 0.5
            star.yScale = 0.5
            star.position = location
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            star.runAction(SKAction.repeatActionForever(action))
            star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.height / 15.0)
            star.physicsBody?.dynamic = true
            self.addChild(star)
            
            let joint = SKPhysicsJointSpring.jointWithBodyA(centerStar.physicsBody!, bodyB: star.physicsBody!, anchorA: centerStar.position, anchorB: star.position)
            physicsWorld.addJoint(joint)
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
