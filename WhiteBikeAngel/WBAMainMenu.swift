//
//  WBAMainMenu.swift
//  WhiteBikeAngel
//
//  Created by Randall Clayborn on 2/17/15.
//  Copyright (c) 2015 claybear39. All rights reserved.
//

import Foundation
import SpriteKit
import iAd

class WBAMainMenu: SKScene, ADBannerViewDelegate {
   //properities
    var howToPlay = SKSpriteNode()
    var credits = SKSpriteNode()
    var title = SKLabelNode()
    var moreGames = SKSpriteNode()
    var playButton = SKSpriteNode()
    var isPlayingSingle = Bool()
    var isInTourament = Bool()
    var angel: WBAPlayer?
    
   override func didMoveToView(view: SKView) {
    isPlayingSingle = false
    isInTourament = false
        
    //set backgroundColor
    backgroundColor = SKColor.blackColor()
    
    //setup background.
    let bg = SKSpriteNode(imageNamed: "WhiteBikemenu")
    bg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.45)
    bg.xScale = 2.0
    bg.yScale = 2.0
    self.addChild(bg)
    
    // Setup title node.
    title = SKLabelNode(fontNamed: "Arial-BoldMT")
    title.text = "White Bike Angel"
    title.fontColor = SKColor.blackColor()
    title.fontSize = 130
    title.alpha = 0.9
    title.position = CGPointMake(size.width * 0.5, size.height - 355)
    addChild(title)
    
    // Setup angel.
    angel = WBAPlayer()
    angel!.position = CGPointMake(self.size.width * 0.5, self.size.height * 1.11)
    angel!.xScale = 2.0
    angel!.yScale = 2.0
    self.addChild(angel!)
    
    // Create Play button.
//    playButton = SKSpriteNode(imageNamed:"playButton")
//    playButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.2)
//    self.addChild(playButton)
    
//    // Create multiplayer button.
//    var levelButton = SKSpriteNode(imageNamed: "MultiPlayerButtonG")
//    levelButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.18)
//    self.addChild(levelButton)

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if (CGRectContainsPoint(playButton.frame, touchLocation)) {
                //call another method or do something here when ClosetDoor is touched.
                playScene()
            }
        }
    }
    
    func playScene() {
        let wait = SKAction.waitForDuration(1.0)
        let block = SKAction.runBlock {
            let transition = SKTransition.flipHorizontalWithDuration(1.0)
            let scene = WBAGamePlayScene(size: self.size)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(scene, transition: transition)
    }
        let sequence = SKAction.sequence([block, wait])
        self.runAction(sequence)

    }
}

