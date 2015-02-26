//
//  GameOverScene.swift
//  GayDaze
//
//  Created by Randall Clayborn on 11/20/14.
//  Copyright (c) 2014 claybear39. All rights reserved.
//

import Foundation
import SpriteKit

let GameOverSound = SKAction.playSoundFileNamed("GameOver.wav", waitForCompletion: true)

class GameOverScene: SKScene {
    let won:Bool
    var winLabel = SKLabelNode()
    var endLabel = SKLabelNode()

    init(size: CGSize, won: Bool) {
    self.won = won
    super.init(size: size)
        
    }
    required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        self.removeFromParent()
        self.removeAllChildren()
        self.removeAllActions()
        
        var background = SKSpriteNode()
        var background2 = SKSpriteNode()
        
        if (won) {
            //create winner's scene then auto which to game play scene.
        background = SKSpriteNode(imageNamed: "won_image.png")
        background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.46)
        self.addChild(background)
            
            winLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
            winLabel.position = CGPointMake(self.size.width * 0.7, self.size.height * 0.7)
            winLabel.text = "You may it back from the dead"
            winLabel.fontColor = SKColor.whiteColor()
            winLabel.alpha = 0.5
            winLabel.fontSize = 40
            addChild(winLabel)
            
            let wait = SKAction.waitForDuration(2.5)
            let block = SKAction.runBlock {
            let myScene = WBAGamePlayScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
            
        self.runAction(SKAction.sequence([wait, block]))
}
      else  if (won == false) {
             //create loser's scene then auto which to game play scene.
            runAction(GameOverSound)
        
            background2 = SKSpriteNode(imageNamed: "youLost.png")
            background2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                background2.yScale = 0.75
            }
            self.addChild(background2)
            
            endLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
            endLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.83)
            endLabel.text = "You will return to the game in one moment."
            endLabel.fontColor = SKColor.whiteColor()
            endLabel.alpha = 1.0
            endLabel.fontSize = 40
            addChild(endLabel)
            
            // Trans back to beginning of Game.
            let wait = SKAction.waitForDuration(2.5)
            let block = SKAction.runBlock {
            let myScene2 = WBAGamePlayScene(size: self.size)
            myScene2.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(myScene2, transition: reveal)
        }
            self.runAction(SKAction.sequence([wait, block]))
        }
    }
    
   override func update(currentTime: CFTimeInterval) {

    }
    
}
