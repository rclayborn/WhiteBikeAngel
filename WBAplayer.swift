//
//  WBAplayer.swift
//  WhiteBikeAngel
//
//  Created by Randall Clayborn on 2/17/15.
//  Copyright (c) 2015 claybear39. All rights reserved.
//

import Foundation
import SpriteKit

//typedef enum : NSUInteger {
//    Running,
//    Jumping,
//    Hurt,
//} PlayerState;


class WBAPlayer: SKNode {
    //properties
    var notFlying = Bool()
    var flying = Bool()
    var accelerating = Bool()
    var player = SKSpriteNode()
    let textureAtlas = SKTextureAtlas(named: "bike.atlas")
    var spriteArray = Array<SKTexture>()
    
    
    override init () {
        super.init()
        //set scene up.
        player = SKSpriteNode(imageNamed: "Bike1")
        player.xScale = 2.0
        player.yScale = 2.0
        
        //setup physic body
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width * 0.5)
        player.physicsBody?.mass = 0.6
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.restitution = 0.6;
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = carCategory | dummyCategory
        player.physicsBody?.contactTestBitMask = carCategory | roadCategory | waterBottleCategory
        self.addChild(player)
        
        //add animation to Player.
        spriteArray.append(textureAtlas.textureNamed("Bike1"))
        spriteArray.append(textureAtlas.textureNamed("Bike2"))
        spriteArray.append(textureAtlas.textureNamed("Bike3"))
        spriteArray.append(textureAtlas.textureNamed("Bike4"))
        let animateAction = SKAction.animateWithTextures(self.spriteArray, timePerFrame: 0.2);
        let repeatAction = SKAction.repeatActionForever(animateAction);
        player.runAction(repeatAction)
        
        flying = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//func flying(flying: Bool) {
//    if (self.flying) {
//        self.actionForKey("kkeyBikeAnimation")
//    }
//}
//
//func notFlying(notFlying: Bool) {
//    self.actionForKey("kkeyBikeAnimation")
//    self.removeActionForKey("kkeyBikeAnimation")
//}

func update()  {
        if (self.flying) {
            player.physicsBody?.velocity = CGVectorMake(0, 0)
            player.physicsBody?.applyForce(CGVectorMake(0, 900))
        }
    
    }
}