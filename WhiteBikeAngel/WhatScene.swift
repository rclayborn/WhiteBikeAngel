//
//  WhatScene.swift
//  BubbleMenuExample
//
//  Created by Randall Clayborn on 12/7/14.
//  Copyright (c) 2014 claybear39. All rights reserved.
//

import Foundation
import SpriteKit

class WhatScene: SKScene {
    let π = CGFloat(M_PI)
    var line6 = SKLabelNode()
    var howToPlayImage = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.darkGrayColor()
        
        let myL = SKLabelNode(fontNamed: "Arial-BoldMT")
        myL.text = "Tap for More"
        myL.fontColor = SKColor.whiteColor()
        myL.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.22)
        myL.fontSize = 50
        myL.zPosition = 0
        myL.xScale = 0.0
        myL.yScale = 0.0
        myL.alpha = 0.5
        addChild(myL)
        
        let appear = SKAction.scaleTo(1.0, duration: 0.2)
        myL.zRotation = -π / 16.0
        let leftWiggle = SKAction.rotateByAngle(π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversedAction()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        let scaleUp = SKAction.scaleBy(1.2, duration: 0.25)
        let scaleDown = scaleUp.reversedAction()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeatAction(group, count: 4)

        let disappear = SKAction.scaleTo(0, duration: 0.0)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        myL.runAction(SKAction.sequence(actions))
        
        howToPlayImage = SKSpriteNode(imageNamed: "HowTo")
        howToPlayImage.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        howToPlayImage.xScale = 4.2
        howToPlayImage.yScale = 4.0
        self.addChild(howToPlayImage)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if (CGRectContainsPoint(howToPlayImage.frame, touchLocation)) {
        
                //self.runAction(popSound)
                playScene()
        }
    }
}

        func playScene() {
                let wait = SKAction.waitForDuration(0.3)
                let block = SKAction.runBlock {
                    let transition = SKTransition.flipHorizontalWithDuration(2.0)
                    let scene = HowToScene(size: self.size)
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    self.view?.presentScene(scene, transition: transition)
                }
                let sequence = SKAction.sequence([block, wait])
                self.runAction(sequence)
                
        }

}
