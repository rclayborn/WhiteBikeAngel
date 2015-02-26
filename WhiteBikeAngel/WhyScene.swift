//
//  WhyScene.swift
//  BubbleMenuExample
//
//  Created by Randall Clayborn on 12/7/14.
//  Copyright (c) 2014 claybear39. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class WhyScene: SKScene {
    
    var line2 = SKLabelNode()
    var line3 = SKLabelNode()
    var line3A = SKLabelNode()
    var line4 = SKLabelNode()
    var line5 = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
         let π = CGFloat(M_PI)
        backgroundColor = SKColor.darkGrayColor()
        
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
        
        let line7 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line7.text = "All programing and art work created by:"
        line7.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 - 450)
        line7.fontSize = 50
        line7.alpha = 0.7
        addChild(line7)
        
        let line8 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line8.text = "Randall Clayborn"
        line8.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 - 550)
        line8.fontSize = 50
        line8.alpha = 0.7
        addChild(line8)
        
        let line9 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line9.text = "Thanks to Red Dogzilla and Major Pain"
        line9.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75 - 650)
        line9.fontSize = 50
        line9.alpha = 0.7
        addChild(line9)

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
