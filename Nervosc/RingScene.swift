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
    let box = SKShapeNode()
    let boxPath: CGMutablePath = CGPathCreateMutable()
    var ball: SKSpriteNode!

    weak var viewController: GameViewController!
    var centerJoint : SKPhysicsJointSpring!

    var jointFrequency: CGFloat = 0.1 {
        didSet{
            if let joint = centerJoint{
                joint.frequency = jointFrequency
                print(jointFrequency)
            }
        }
    }
    var jointDamping: CGFloat = 0.1 {
        didSet{
            if let joint = centerJoint{
                joint.damping = jointDamping
                print(jointDamping)
            }
        }
    }
    
    var ballMass: CGFloat = 0.1 {
        didSet{
            if let node = ball{
//                node.physicsBody?.mass = ballMass
//                print(ballMass)
            }
        }
    }
    var ballDensity: CGFloat = 0.000001 {
        didSet{
            if let node = ball{
                node.physicsBody?.density = ballDensity
                print(ballDensity)
            }
        }
    }
    var ballFriction: CGFloat = 0.1 {
        didSet{
            if let node = ball{
                node.physicsBody?.friction = ballFriction
                print(ballFriction)
            }
        }
    }
    var ballRestitution: CGFloat = 0.1 {
        didSet{
            if let node = ball{
                node.physicsBody?.restitution = ballRestitution
                print(ballRestitution)
            }
        }
    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = SKColor.blackColor()
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        // BALL
        ball = SKSpriteNode(imageNamed: "ball")
        
        
        // RING CENTER
        ringCenter.xScale = 0.2
        ringCenter.yScale = 0.2
        ringCenter.position = CGPoint(x:(self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        ringCenter.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        ringCenter.physicsBody?.dynamic = false
        ringCenter.physicsBody?.restitution = 0
        ringCenter.physicsBody?.density = 10000
        ringCenter.name = "ringCenter"
        self.addChild(ringCenter)
        
        
        // CIRCLE BOX
        CGPathAddArc(boxPath, nil, 0, 0, 300, 0, CGFloat(M_PI * 2.0), true)
        box.path = boxPath
        box.lineWidth = 10
        box.fillColor = SKColor.whiteColor()
        box.alpha = 0.2
        box.strokeColor = SKColor.blueColor()
        box.glowWidth = 2
        box.position = CGPoint(x:(self.view?.frame.midX)!, y: (self.view?.frame.midY)! )
        box.physicsBody = SKPhysicsBody(edgeLoopFromPath: boxPath)
        box.physicsBody?.dynamic = false
        self.addChild(box)
        
        // BALL
        ball.position = CGPoint(x:(self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2)
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.density = 0.001
        ball.name = "ball"
        



        self.addChild(ball)
        
        
        centerJoint = SKPhysicsJointSpring.jointWithBodyA(
            ringCenter.physicsBody!,
            bodyB: ball.physicsBody!,
            anchorA: ringCenter.position,
            anchorB: ball.position)
        centerJoint.frequency = 1
        centerJoint.damping = 0.1
        physicsWorld.addJoint(centerJoint)
        

    }
    
    func onDampSlider(slider:UISlider){
        centerJoint?.damping = CGFloat(slider.value)
        print(centerJoint?.damping)
    }
    
    func onFreqSlider(slider:UISlider){
        centerJoint?.frequency = CGFloat(slider.value) * CGFloat(20)
        print(centerJoint?.frequency)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if let touchedNode = self.nodeAtPoint(location) as SKNode!{
                

                let pointer = SKSpriteNode(imageNamed:"pointer")
                pointer.xScale = 1.0
                pointer.yScale = 1.0
                
                // Trick : the initial position is set as the same as the ball, so that the spring length is 0.
                // (there is no actual length property for the spring joint);
                pointer.position = ball.position
                pointer.physicsBody = SKPhysicsBody(circleOfRadius: pointer.size.height/2)
                pointer.physicsBody?.dynamic = false
                pointer.name = "pointer"
                self.addChild(pointer)
                
                let joint = SKPhysicsJointSpring.jointWithBodyA(
                    ball.physicsBody!,
                    bodyB: pointer.physicsBody!,
                    anchorA: ball.position,
                    anchorB: pointer.position)
                joint.frequency = centerJoint.frequency * 2
                joint.damping = centerJoint.damping / 2
                physicsWorld.addJoint(joint)

                // Once the spring length is initialized, the pointer can be set to the finger-touch position again.
                pointer.position = location
                
            }
            
        }
    }
    

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

        self.enumerateChildNodesWithName("pointer") {
            node, stop in
            // do something with node or stop
            node.removeFromParent()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches{
            self.enumerateChildNodesWithName("pointer") {
                node, stop in
                // do something with node or stop
                node.position = touch.locationInNode(self)
            }
        }
    }
    
    
    
    // Happens before physics simulation
    override func didEvaluateActions() {
        

        
        // Send OSC message for all star nodes
        self.enumerateChildNodesWithName("ball") {
            node, stop in
            // do something with node or stop
            
            if let joint = node.physicsBody?.joints[0]{
                let length = (joint.reactionForce.dx * joint.reactionForce.dx) + (joint.reactionForce.dy * joint.reactionForce.dy)
                self.nerve.sendMessage("/joint/force \(length )")
            }
            
            self.nerve.sendMessage("/ball/velocity \((node.physicsBody?.velocity.dx)!)")
            
            
            //TODO: send vall velocity and joint reaction force
        }
        
        
    }
    
}
