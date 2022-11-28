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
    let boxPath: CGMutablePath = CGMutablePath()
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

    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = SKColor.black
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        // BALL
        ball = SKSpriteNode(imageNamed: "ball")
        
        
        // RING CENTER
        ringCenter.xScale = 0.2
        ringCenter.yScale = 0.2
        ringCenter.position = CGPoint(x:(self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        ringCenter.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        ringCenter.physicsBody?.isDynamic = false
        ringCenter.physicsBody?.restitution = 0
        ringCenter.physicsBody?.density = 10000
        ringCenter.name = "ringCenter"
        self.addChild(ringCenter)
        
        
        // CIRCLE BOX

        boxPath.addArc(center: CGPoint(x: 0,y: 0), radius: 300, startAngle: 0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
    
        box.path = boxPath
        box.lineWidth = 10
        box.fillColor = SKColor.white
        box.alpha = 0.2
        box.strokeColor = SKColor.blue
        box.glowWidth = 2
        box.position = CGPoint(x:(self.view?.frame.midX)!, y: (self.view?.frame.midY)! )
        box.physicsBody = SKPhysicsBody(edgeLoopFrom: boxPath)
        box.physicsBody?.isDynamic = false
        self.addChild(box)
        
        // BALL
        ball.position = CGPoint(x:(self.view?.frame.midX)!, y: (self.view?.frame.midY)!)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.density = 0.001
        ball.name = "ball"
        

        self.addChild(ball)
        
        
        centerJoint = SKPhysicsJointSpring.joint(
            withBodyA: ringCenter.physicsBody!,
            bodyB: ball.physicsBody!,
            anchorA: ringCenter.position,
            anchorB: ball.position)
        centerJoint.frequency = 1
        centerJoint.damping = 0.1
        physicsWorld.add(centerJoint)
        

    }
    
    func onDampSlider(slider:UISlider){
        centerJoint?.damping = CGFloat(slider.value)
        print(centerJoint?.damping)
    }
    
    func onFreqSlider(slider:UISlider){
        centerJoint?.frequency = CGFloat(slider.value) * CGFloat(20)
        print(centerJoint?.frequency)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if (self.atPoint(location) as SKNode) != nil {
                

                let pointer = SKSpriteNode(imageNamed:"pointer")
                pointer.xScale = 1.0
                pointer.yScale = 1.0
                
                // Trick : the initial position is set as the same as the ball, so that the spring length is 0.
                // (there is no actual length property for the spring joint);
                pointer.position = ball.position
                pointer.physicsBody = SKPhysicsBody(circleOfRadius: pointer.size.height/2)
                pointer.physicsBody?.isDynamic = false
                pointer.name = "pointer"
                self.addChild(pointer)
                
                let joint = SKPhysicsJointSpring.joint(
                    withBodyA: ball.physicsBody!,
                    bodyB: pointer.physicsBody!,
                    anchorA: ball.position,
                    anchorB: pointer.position)
                joint.frequency = centerJoint.frequency * 2
                joint.damping = centerJoint.damping / 2
                physicsWorld.add(joint)

                // Once the spring length is initialized, the pointer can be set to the finger-touch position again.
                pointer.position = location
                
            }
            
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.enumerateChildNodes(withName: "pointer") {
            node, stop in
            // do something with node or stop
            node.removeFromParent()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            self.enumerateChildNodes(withName: "pointer") {
                node, stop in
                // do something with node or stop
                node.position = touch.location(in: self)
            }
        }
    }
    
    
    
    // Happens before physics simulation
    override func didEvaluateActions() {
        

        
        // Send OSC message for all star nodes
        self.enumerateChildNodes(withName: "ball") {
            node, stop in
            // do something with node or stop
            
            if let joint = node.physicsBody?.joints[0]{
                let length = (joint.reactionForce.dx * joint.reactionForce.dx) + (joint.reactionForce.dy * joint.reactionForce.dy)
                self.nerve!.sendMessage("/joint/force \(length )")
            }
            
            self.nerve?.sendMessage("/ball/velocity \((node.physicsBody?.velocity.dx)!)")
            
            
            //TODO: send vall velocity and joint reaction force
        }
        
        
    }
    
}
