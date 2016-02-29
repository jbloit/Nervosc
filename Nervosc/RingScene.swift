//
//  RingScene.swift
//  Nervosc
//
//  Created by julien@macmini on 26/02/16.
//  Copyright (c) 2016 jbloit. All rights reserved.
//

import SpriteKit

class RingScene: SKScene {
    
    let nerve = Nerve.sharedInstance()
    let starIcon = SKSpriteNode(imageNamed:"star")
    let ringCenter = SKSpriteNode(imageNamed: "ringIcon")
    let box = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = SKColor.blackColor()
        physicsWorld.gravity = CGVectorMake(0, -10)
        
        // RING CENTER
        ringCenter.xScale = 0.7
        ringCenter.yScale = 0.7
        ringCenter.position = CGPoint(x:(self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        ringCenter.physicsBody = SKPhysicsBody(circleOfRadius: ringCenter.size.height / 15.0)
        ringCenter.physicsBody?.dynamic = false
        
        ringCenter.name = "ringCenter"
        self.addChild(ringCenter)
        
        
        // BOX
        box.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(
            scene!.size.width * 0.5,
            scene!.size.height * 0.5,
            scene!.size.width * 0.5,
            scene!.size.height * 0.5))
        box.physicsBody?.dynamic = false
        self.addChild(box)
        
        // SCENE TRANSITION BUTTON
        starIcon.xScale = 1
        starIcon.yScale = 1
        starIcon.position = CGPoint(x:(self.view?.frame.midX)! * 0.2, y: (self.view?.frame.height)! * 0.9)
        starIcon.name = "starIcon"
        self.addChild(starIcon)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if let touchedNode = self.nodeAtPoint(location) as SKNode!{
                
                if (touchedNode.name == "starIcon"){
                    print("STAR ICON")
                    let transitionLeft = SKTransition.revealWithDirection(.Left, duration: 0.5)
                    let nextScene = GameScene(size: scene!.size)
                    nextScene.scaleMode = .AspectFill
                    self.view?.presentScene(nextScene, transition: transitionLeft)
                    return
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
                
                
                let joint = SKPhysicsJointSpring.jointWithBodyA(
                    ringCenter.physicsBody!,
                    bodyB: star.physicsBody!,
                    anchorA: ringCenter.position,
                    anchorB: star.position)
                joint.frequency = 20
                joint.damping = 0.1
                
                physicsWorld.addJoint(joint)
                
            }
            
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
