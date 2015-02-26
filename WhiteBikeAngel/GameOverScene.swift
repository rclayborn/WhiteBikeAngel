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
    var points = Int()
    let won:Bool
    var highScore = NSInteger()
    var Score = HighScore()
    var highScoreLabel = SKLabelNode()

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
        
        var retrievedHighScore = SaveHighScore().RetrieveHighScore() as HighScore
        //println(retrievedHighScore.highScore)
        highScore += 1
        
        if highScore >= 1 {
            self.highScore + self.highScore
            
            SaveHighScore().ArchiveHighScore(highScore: self.Score)
           // highScoreLabel.text = "High Score: \(self.highScore)"
        }
        
        if (won) {
       // println("GameOver win")
        var retrievedHighScore = SaveHighScore().RetrieveHighScore() as HighScore
        println(retrievedHighScore.highScore)
            
        background = SKSpriteNode(imageNamed: "won_image.png")
        background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.46)
        self.addChild(background)
            
            highScoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
            highScoreLabel.position = CGPointMake(self.size.width * 0.7, self.size.height * 0.1)
            highScoreLabel.text = "You may it back from the dead: \(highScore)"
            highScoreLabel.fontColor = SKColor.whiteColor()
            highScoreLabel.fontSize = 40
            addChild(highScoreLabel)
            
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
            runAction(GameOverSound)
        
            background2 = SKSpriteNode(imageNamed: "youLost.png")
            background2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                background2.yScale = 0.75
            }
            self.addChild(background2)
            
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
    
        highScoreLabel.text = "\(self.highScore)"

    }
    
}
