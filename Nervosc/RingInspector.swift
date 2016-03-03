//
//  RingInspector.swift
//  NervoscDaemon
//
//  Created by julien@macmini on 03/03/16.
//  Copyright © 2016 jbloit. All rights reserved.
//

import UIKit

class RingInspector: UIView {

    dynamic var frequencyValue: CGFloat = 0.0
    dynamic var dampValue: CGFloat = 0.0
    dynamic var ballMass: CGFloat = 0.0
    dynamic var ballDensity: CGFloat = 0.0
    dynamic var ballFriction: CGFloat = 0.0
    dynamic var ballRestitution: CGFloat = 0.0
    
    let freqSlider: UISlider = UISlider()
    let dampSlider: UISlider = UISlider()
    let ballMassSlider: UISlider = UISlider()
    let ballDensitySlider: UISlider = UISlider()
    let ballFrictionSlider: UISlider = UISlider()
    let ballRestitutionSlider: UISlider = UISlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let sliderHeight = CGFloat(50)
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        freqSlider.frame = CGRectMake(0, sliderHeight * 0, bounds.size.width, sliderHeight)
        freqSlider.addTarget(self, action: "onFreqSlider:", forControlEvents: .ValueChanged)
        self.addSubview(freqSlider)
        
        dampSlider.frame = CGRectMake(0, sliderHeight, bounds.size.width, sliderHeight)
        dampSlider.addTarget(self, action: "onDampSlider:", forControlEvents: .ValueChanged)
        self.addSubview(dampSlider)
        
        ballMassSlider.frame = CGRectMake(0, sliderHeight*2, bounds.size.width, sliderHeight)
        ballMassSlider.addTarget(self, action: "onBallMassSlider:", forControlEvents: .ValueChanged)
        self.addSubview(ballMassSlider)
        
        ballDensitySlider.frame = CGRectMake(0, sliderHeight*3, bounds.size.width, sliderHeight)
        ballDensitySlider.addTarget(self, action: "onBallDensitySlider:", forControlEvents: .ValueChanged)
        self.addSubview(ballDensitySlider)
        
        ballFrictionSlider.frame = CGRectMake(0, sliderHeight*4, bounds.size.width, sliderHeight)
        ballFrictionSlider.addTarget(self, action: "onBallFrictionSlider:", forControlEvents: .ValueChanged)
        self.addSubview(ballFrictionSlider)
        
        ballRestitutionSlider.frame = CGRectMake(0, sliderHeight*5, bounds.size.width, sliderHeight)
        ballRestitutionSlider.addTarget(self, action: "onballRestitutionSlider:", forControlEvents: .ValueChanged)
        self.addSubview(ballRestitutionSlider)
        
    }

    func onFreqSlider(slider : UISlider){
        frequencyValue = CGFloat(slider.value * Float(2))
    }
    
    func onDampSlider(slider : UISlider){
        dampValue = CGFloat(slider.value * Float(20))
    }
    
    func onBallMassSlider(slider : UISlider){
        ballMass = CGFloat(slider.value * Float(120) + 0.001)
    }
    
    func onBallDensitySlider(slider : UISlider){
        ballDensity = CGFloat(slider.value * Float(20) + 0.001)
    }
    
    func onBallFrictionSlider(slider : UISlider){
        ballFriction = CGFloat(slider.value * Float(1))
    }
    
    func onballRestitutionSlider(slider : UISlider){
        ballRestitution = CGFloat(slider.value * Float(1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    
//    node.physicsBody?.mass = ballMass
//}
//}
//}
//var ballDensity: CGFloat = 0.1 {
//didSet{
//    if let node = ball{
//        node.physicsBody?.density = ballDensity
//    }
//}
//}
//var ballFriction: CGFloat = 0.1 {
//didSet{
//    if let node = ball{
//        node.physicsBody?.friction = ballFriction
//    }
//}
//}
//var ballRestitution: CGFloat = 0.1 {
//didSet{
//    if let node = ball{
//        node.physicsBody?.restitution = ballRestitution

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
