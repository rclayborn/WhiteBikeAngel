//
//  WhoScene.swift
//  BubbleMenuExample
//
//  Created by Randall Clayborn on 12/7/14.
//  Copyright (c) 2014 claybear39. All rights reserved.
//

import Foundation
import SpriteKit

class WhoScene: SKScene {
    
    let π = CGFloat(M_PI)
    var line6 = SKLabelNode()
    //var Share = SocialSharingViewController()
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.darkGrayColor()
        
        let myL = SKLabelNode(fontNamed: "Arial-BoldMT")
        myL.text = "White Bike Angel"
        myL.fontColor = SKColor.blackColor()
        myL.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        myL.fontSize = 120
        myL.zPosition = 0
        myL.xScale = 0.0
        myL.yScale = 0.0
        myL.alpha = 0.8
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
        let groupWait = SKAction.repeatAction(group, count:3)
        let resetWiggle = SKAction.rotateByAngle(π/16.0, duration: 0.2)
        let disappear = SKAction.scaleTo(0, duration: 0.0)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, resetWiggle, disappear, removeFromParent]
        myL.runAction(SKAction.sequence(actions))

        let myX = SKLabelNode(fontNamed: "Arial-BoldMT")
        myX.text = "Who?"
        myX.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.7)
        myX.fontSize = 95
        myX.alpha = 1.0
        addChild(myX)
        
        let line2 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line2.text = "All programing and art work created by:"
        line2.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.7 - 50)
        line2.fontSize = 50
        line2.alpha = 0.7
        addChild(line2)
        
        let line3 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line3.text = "Randall Clayborn"
        line3.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.7 - 100)
        line3.fontSize = 50
        line3.alpha = 0.7
        addChild(line3)
        
        let line4 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line4.text = "Thanks to Red Dogzilla and Major Pain"
        line4.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.35)
        line4.fontSize = 50
        line4.alpha = 0.7
        addChild(line4)
        
        let line5 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line5.text = "Play more games by this creator here:"
        line5.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.3)
        line5.fontSize = 50
        line5.alpha = 0.7
        addChild(line5)
        
        line6 = SKLabelNode(fontNamed: "Arial-BoldMT")
        line6.text = "Games that tell a story"
        line6.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.3 - 55)
        line6.fontSize = 50
        line6.alpha = 1.0
        addChild(line6)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if (CGRectContainsPoint(line6.frame, touchLocation)) {
            //Go to Apple Store my page.
               // self.runAction(popSound)
                UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/artist/randall-clayborn/id704631046")!)
                            
            }
        }
    }
}
