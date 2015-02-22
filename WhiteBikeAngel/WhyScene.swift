//
//  WhyScene.swift
//  BubbleMenuExample
//
//  Created by Randall Clayborn on 12/7/14.
//  Copyright (c) 2014 claybear39. All rights reserved.
//

import Foundation
import SpriteKit

class WhyScene: SKScene {
    
    var line2 = SKLabelNode()
    var line3 = SKLabelNode()
    var line3A = SKLabelNode()
    var line4 = SKLabelNode()
    var line5 = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
         let π = CGFloat(M_PI)
        backgroundColor = SKColor.darkGrayColor()
        
        let myL = SKLabelNode(fontNamed: "Arial-BoldMT")
        myL.text = "White Bike Angel"
        myL.fontColor = SKColor.blackColor()
        myL.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.3)
        myL.fontSize = 160
        myL.zPosition = 0
        myL.xScale = 0.0
        myL.yScale = 0.0
        addChild(myL)
        
        let appear = SKAction.scaleTo(1.0, duration: 0.2)
        myL.zRotation = -π / 16.0
        let leftWiggle = SKAction.rotateByAngle(π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversedAction()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        let scaleUp = SKAction.scaleBy(1.2, duration: 0.25)
        let scaleDown = scaleUp.reversedAction()
        let fullScale = SKAction.sequence(
            [scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeatAction(group, count: 3)

        let disappear = SKAction.scaleTo(0, duration: 0.1)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        myL.runAction(SKAction.sequence(actions))
        
        let line1 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line1.text = "Why?"
        line1.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 + 40)
        line1.fontSize = 120
        line1.alpha = 0.8
        addChild(line1)
        
        line2 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line2.text = "Twitter"
        line2.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 - 200)
        line2.fontSize = 70
        line2.alpha = 0.7
        addChild(line2)
        
        line3 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line3.text = "stop Music"
        line3.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 - 50)
        line3.fontSize = 70
        line3.alpha = 0.7
        addChild(line3)
        
        line3A = SKLabelNode(fontNamed: "Arial-BoldMT")
        line3A.text = "start Music"
        line3A.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 - 125)
        line3A.fontSize = 70
        line3A.alpha = 0.7
        addChild(line3A)

        
        line4 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line4.text = "Facebook"
        line4.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 - 275)
        line4.fontSize = 70
        line4.alpha = 0.7
        addChild(line4)
        
        line5 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line5.text = "More Games"
        line5.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 - 350)
        line5.fontSize = 70
        line5.alpha = 0.7
        addChild(line5)
        
        let line6 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line6.text = "ENJOY!"
        line6.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 - 475)
        line6.fontSize = 100
        line6.alpha = 0.8
        addChild(line6)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if (CGRectContainsPoint(line2.frame, touchLocation)) {
                //twitter
               //self.runAction(popSound)
                NSNotificationCenter.defaultCenter().postNotificationName("CallTheNotification", object: nil)
            }
            if (CGRectContainsPoint(line3.frame, touchLocation)) {
                //Stop Music
               // self.runAction(popSound)
                line3A.alpha = 0.7
                line3.alpha = 0.3
                
                 SKTAudio.sharedInstance().pauseBackgroundMusic()
            }
            if (CGRectContainsPoint(line3A.frame, touchLocation)) {
                //Restart Music
               // self.runAction(popSound)
                line3A.alpha = 0.3
                line3.alpha = 0.7
                
                SKTAudio.sharedInstance().resumeBackgroundMusic()
                
            }
            if (CGRectContainsPoint(line4.frame, touchLocation)) {
                //facebook
               // self.runAction(popSound)
                 NSNotificationCenter.defaultCenter().postNotificationName("CallTheFacebook", object: nil)  
            }
            if (CGRectContainsPoint(line5.frame, touchLocation)) {
                //Apple store
              //  self.runAction(popSound)
                 UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/artist/randall-clayborn/id704631046")!)
            }
        }
    }

}
