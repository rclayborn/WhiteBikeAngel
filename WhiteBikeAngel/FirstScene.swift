//
//  FirstScene.swift
//  BubbleMenuExample
//
//  Created by Randall Clayborn on 12/7/14.
//  Copyright (c) 2014 claybear39. All rights reserved.
//

import Foundation
import SpriteKit

class FirstScene: SKScene {
    let π = CGFloat(M_PI)
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.redColor()
        playScene()
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
