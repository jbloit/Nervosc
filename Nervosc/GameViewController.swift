//
//  GameViewController.swift
//  Nervosc
//
//  Created by julien@macmini on 26/02/16.
//  Copyright (c) 2016 jbloit. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var currentScene: SKScene!
    var inspector: RingInspector!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = RingScene(fileNamed:"RingScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
            
            // bind scene and controller
            currentScene = scene
            scene.viewController = self

            inspector = RingInspector(frame: CGRectMake(0, 0, 200, self.view.frame.size.height))
            self.view.addSubview(inspector)
            
            inspector.addObserver(self, forKeyPath: "frequencyValue", options: .new, context: nil)
            inspector.addObserver(self, forKeyPath: "dampValue", options: .new, context: nil)
            inspector.addObserver(self, forKeyPath: "ballMass", options: .new, context: nil)
            inspector.addObserver(self, forKeyPath: "ballDensity", options: .new, context: nil)
            inspector.addObserver(self, forKeyPath: "ballFriction", options: .new, context: nil)
            inspector.addObserver(self, forKeyPath: "ballRestitution", options: .new, context: nil)
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[NSKeyValueChangeKey.newKey] {

            
            if (keyPath! == "frequencyValue"){
                if let myscene = currentScene as! RingScene!{
                    myscene.jointFrequency = newValue as! CGFloat
                }
            }
            if (keyPath! == "dampValue"){
                if let myscene = currentScene as! RingScene!{
                    myscene.jointDamping = newValue as! CGFloat
                }
            }
            if (keyPath! == "ballMass"){
                if let myscene = currentScene as! RingScene!{
                    myscene.ballMass = newValue as! CGFloat
                }
            }
            if (keyPath! == "ballDensity"){
                if let myscene = currentScene as! RingScene!{
                    myscene.ballDensity = newValue as! CGFloat
                }
            }
            if (keyPath! == "ballFriction"){
                if let myscene = currentScene as! RingScene!{
                    myscene.ballFriction = newValue as! CGFloat
                }
            }
            if (keyPath! == "ballRestitution"){
                if let myscene = currentScene as! RingScene!{
                    myscene.ballRestitution = newValue as! CGFloat
                }
            }
            
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        inspector?.removeObserver(self, forKeyPath: "frequencyValue", context: nil)
        inspector?.removeObserver(self, forKeyPath: "dampValue", context: nil)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return UIInterfaceOrientationMask.landscape
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
