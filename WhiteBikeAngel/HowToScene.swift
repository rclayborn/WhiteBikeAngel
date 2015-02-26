//
//  HowToScene.swift
//  WhiteBikeAngel
//
//  Created by Randall Clayborn on 2/17/15.
//  Copyright (c) 2015 claybear39. All rights reserved.
//

import Foundation
import SpriteKit


class HowToScene: SKScene {
    //properties
    var backButton = SKLabelNode()
    var moreInfo = SKSpriteNode()
     let π = CGFloat(M_PI)
    
    override func didMoveToView(view: SKView) {
        //set scene up.
        moreInfo = SKSpriteNode(imageNamed: "HowMore")
        moreInfo.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5)
        moreInfo.xScale = 2.2
        moreInfo.yScale = 1.9
        self.addChild(moreInfo)
        
        backButton = SKLabelNode(fontNamed: "Arial-BoldMT")
        backButton.fontSize = 50
        backButton.fontColor = SKColor.whiteColor()
        backButton.text = "Tap to PLAY"
        backButton.alpha = 0.5
        backButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.22)
        self.addChild(backButton)
        
        let appear = SKAction.scaleTo(1.0, duration: 0.2)
        backButton.zRotation = -π / 16.0
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
        backButton.runAction(SKAction.sequence(actions))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if (CGRectContainsPoint(moreInfo.frame, touchLocation)) {
                
                //self.runAction(popSound)
                playScene()
            }
        }
    }
    
    func playScene() {
        let wait = SKAction.waitForDuration(0.3)
        let block = SKAction.runBlock {
            let transition = SKTransition.flipHorizontalWithDuration(2.0)
            let scene = WBAGamePlayScene(size: self.size)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(scene, transition: transition)
        }
        let sequence = SKAction.sequence([block, wait])
        self.runAction(sequence)
        
    }
    
}
