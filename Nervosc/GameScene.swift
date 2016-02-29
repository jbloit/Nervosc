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
    
    let ringIcon = SKSpriteNode(imageNamed: "ringIcon")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = SKColor.blackColor()
        
        physicsWorld.gravity = CGVectorMake(0, -10)

        // CENTER STAR
        centerStar.xScale = 1.0
        centerStar.yScale = 1.0
        centerStar.position = CGPoint(x: (self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        centerStar.physicsBody = SKPhysicsBody(circleOfRadius: centerStar.size.height / 15.0)
        centerStar.physicsBody?.dynamic = false
        self.addChild(centerStar)
        
        // SCENE TRANSITION BUTTON
        ringIcon.xScale = 0.5
        ringIcon.yScale = 0.5
        ringIcon.position = CGPoint(x:(self.view?.frame.midX)! * 0.2, y: (self.view?.frame.height)! * 0.9)
        ringIcon.name = "ringIcon"
        self.addChild(ringIcon)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

        
        for touch in touches {
        
            let location = touch.locationInNode(self)
        
            if let touchedNode = self.nodeAtPoint(location) as SKNode!{
                
                if (touchedNode.name == "ringIcon"){
                    print("RING ICON")
                    let transitionRight = SKTransition.revealWithDirection(.Right, duration: 0.5)
                    let nextScene = RingScene(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    self.view?.presentScene(nextScene, transition: transitionRight)
                    return
                }
            
            }
            
            
            let star = SKSpriteNode(imageNamed:"star")
            star.xScale = 0.5
            star.yScale = 0.5
            star.position = location
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            star.runAction(SKAction.repeatActionForever(action))
            star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.height / 15.0)
            star.physicsBody?.dynamic = true
            star.name = "star"
            self.addChild(star)
            
            let joint = SKPhysicsJointSpring.jointWithBodyA(centerStar.physicsBody!, bodyB: star.physicsBody!, anchorA: centerStar.position, anchorB: star.position)
            physicsWorld.addJoint(joint)

        }
    }
    
   // Happens before physics simulation
    override func didEvaluateActions() {
        
        // Send OSC message for all star nodes
        
        self.enumerateChildNodesWithName("star") {
            node, stop in
            // do something with node or stop
            self.nerve.sendMessage("/star/position/x \(node.position.x )")
        }

        
    }
    
}
