//
//  WBAGamePlayScene.swift
//  WhiteBikeAngel
//
//  Created by Randall Clayborn on 2/17/15.
//  Copyright (c) 2015 claybear39. All rights reserved.
//

import Foundation
import SpriteKit

extension CGFloat {
    static func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UInt32.max)) }
    static func random(#min: CGFloat, max: CGFloat) -> CGFloat { assert(min < max)
    return CGFloat.random() * (max - min) + min
    }
}

let playerCategory: UInt32 = 0x1 << 0
let roadCategory: UInt32 = 0x1 << 1
let waterBottleCategory: UInt32 = 0x1 << 2
let carCategory: UInt32 = 0x1 << 4
let dummyCategory: UInt32 = 0x1 << 8
let skullCategory: UInt32 = 0x1 << 16
let baseCategory: UInt32 = 0x1 << 24


 class WBAGamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    var score = CGFloat()
    //var animation = SKAction()
    var health = Double()
    var maxHealth = Float()
    let healthMeterLabel = SKLabelNode(fontNamed:"Arial")

    //var player = WBAPlayer()
    var player = SKSpriteNode()
    var notFlying = Bool()
    var flying = Bool()
    var accelerating = Bool()
    let textureAtlas = SKTextureAtlas(named: "bike.atlas")
    var spriteArray = Array<SKTexture>()

    //var flightAnimation = SKAction()
    var inflight = Bool()
    //var road = SKSpriteNode()
    var inPlay = Bool()
    var forgroundFog = SKSpriteNode()
    
    //var dt = NSTimeInterval()
    var velocity = CGPoint()
    var gameOver = Bool()
    var scoreLabel = SKLabelNode()
    
    var healthBar = NSString()
    var damageTakenPerShot = Int()
    var healthMeterText: NSString = "========================================"
    var healthBarLength = Double()
    
    var beginLabel = SKLabelNode()
    let car = SKSpriteNode()
    let bottle = SKSpriteNode()
    
    //let spawnAction = SKAction.self()//setspawnAction.
    let playableRect: CGRect
    
    var levelTimeLimit = 0.0
    var timeLabel: SKLabelNode!
    var currentTime = 0.0
    var startTime = 0.0
    var elapsedTime = 0.0
    var timeRemaining = 0
    
        override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin,
        width: size.width,
        height: playableHeight)
            
        super.init(size: size)
            debugDrawPlayableArea()
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func debugDrawPlayableArea() {
            let shape = SKShapeNode()
            let path = CGPathCreateMutable()
            CGPathAddRect(path, nil, playableRect)
            shape.path = path
            shape.strokeColor = SKColor.redColor()
            shape.lineWidth = 4.0
            shape.zPosition = 900
            addChild(shape)
        }
        
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = SKColor.blackColor()
        self.paused = false
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(-0, -5)
        //self.userInteractionEnabled = true

        health = 100
        damageTakenPerShot = 12
        gameOver = true
        inflight = true
        inPlay = false
        levelTimeLimit = 60
        
        //Setup physic
        self.physicsWorld.gravity = CGVectorMake(0.0, -2.0);
        
        //create Begin Label to start spawning and timer.
        beginLabel = SKLabelNode(fontNamed: "CopperPlate")
        beginLabel.fontSize = 100
        beginLabel.fontColor = SKColor.greenColor()
        beginLabel.text = "Tap to Begin";
        beginLabel.alpha = 0.6;
        beginLabel.xScale = 1.0;
        beginLabel.yScale = 1.0
        beginLabel.zPosition = 400;
        beginLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        self.addChild(beginLabel)
        
        //setup foreGround. (Static)
        let foreground = SKSpriteNode(imageNamed: "foregroundFog")
        foreground.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.4)
        foreground.xScale = 2.0
        foreground.yScale = 2.0
        foreground.zPosition = 300;
        self.addChild(foreground)
        
        // Setup the health bar
        healthMeterLabel.name = "healthMeter";
        healthMeterLabel.fontSize = 30
        healthMeterLabel.fontColor = SKColor.whiteColor()
        healthMeterLabel.text = healthMeterText;
        healthMeterLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height-250);
        healthMeterLabel.alpha = 0.4;
        healthMeterLabel.zPosition = 900
        self.addChild(healthMeterLabel)
        
        var groundTexture = SKTexture(imageNamed: "blackSky")
        groundTexture.filteringMode = SKTextureFilteringMode.Nearest
       
        var moveBg = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: NSTimeInterval(0.01 * groundTexture.size().width))
        var resetGroundSprite = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0.0)
        var moveGroundSpriteForever = SKAction.repeatActionForever(SKAction.sequence([moveBg, resetGroundSprite]))
        
        for var i:CGFloat = 0; i<2 + self.frame.size.width / (groundTexture.size().width); ++i {
            var sprite = SKSpriteNode(texture: groundTexture)
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2)
            sprite.runAction(moveGroundSpriteForever)
            sprite.zPosition = -1
            sprite.anchorPoint = CGPointMake(0.5, 0.4)
            self.addChild(sprite)
        }
        //this method helps keep player in playble area on scene.
        var dummy = SKNode()
        dummy.position = CGPointMake(self.size.width * 0.0, self.size.height * 0.0)
        dummy.physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        dummy.physicsBody?.restitution = 0.7
        dummy.physicsBody?.categoryBitMask = dummyCategory
        dummy.physicsBody?.collisionBitMask = playerCategory
        self.addChild(dummy)

        var base = SKNode()//this is the road base for the car and skull.
        base.position = CGPointMake(self.size.width * 0.0, self.size.height * 0.0)
        base.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0,y: 220), toPoint: CGPoint(x: 2500,y: 220))
        base.physicsBody?.restitution = 0.7
        base.physicsBody?.categoryBitMask = baseCategory
        base.physicsBody?.collisionBitMask = playerCategory | carCategory
        self.addChild(base)

        self.maxHealth = 100;
        createPlayer()
        createRoad()
        addGameUI()
    }
    
    func beginButton() {
        
        inPlay = true
        beginLabel.setScale(0.0)
        startTime = currentTime
        beginGamePlay()
    }
 
    func beginGamePlay() {
        score = 0
        SKTAudio.sharedInstance().playBackgroundMusic("whiteBikeSong1.mp3")
        
        //spawn Enemy.
        var wait = SKAction.waitForDuration(2.5)
        var run = SKAction.runBlock {
            self.spawnEnemy()
  }
        self.runAction(SKAction.sequence([wait, run]))
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])),withKey: "spawnEnemy")//with key
        
        //spawn WaterBottle.
        var waitBottle = SKAction.waitForDuration(6.0)
        var runBottle = SKAction.runBlock {
            self.spawnWaterBottle()
        }
        self.runAction(SKAction.sequence([waitBottle, runBottle]))
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitBottle, runBottle])),withKey: "spawnWaterBottle")
        
        //Spawn Skull
        var waitSkull = SKAction.waitForDuration(3.0)
        var runSkull = SKAction.runBlock {
            //code here to spawn or add method
            self.spawnSkull()
        }
        self.runAction(SKAction.sequence([waitSkull, runSkull]))
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitSkull, runSkull])),withKey: "spawnSkull")
    }
    
    func addGameUI() {
        timeLabel = SKLabelNode(fontNamed: "Thonburi")
        //time.text = "Time: \(timeInSecounds)"//setup in updte method.
        timeLabel.fontSize = 50;
        timeLabel.alpha = 0.6;
        timeLabel.fontColor = UIColor.whiteColor()
        timeLabel.position = CGPointMake(self.size.width * 0.2, self.size.height * 0.83);
        timeLabel.zPosition = 901
        self.addChild(timeLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Thonburi")
        //scoreLabel.text = "Score: \(noOfScore)"//setup in updte method.
        scoreLabel.fontSize = 50;
        scoreLabel.alpha = 0.6;
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.position = CGPointMake(self.size.width * 0.8, self.size.height * 0.83);
        scoreLabel.zPosition = 901
        self.addChild(scoreLabel)

    }
    
    func spawnWaterBottle() {
        // create bottle.
        println("waterBottle has been spawned")
        var bottle = SKSpriteNode(imageNamed: "bottle")
        bottle.position = CGPointMake(self.size.width * 0.08, self.size.height * 0.84)
        bottle.xScale = 1.0
        bottle.yScale = 1.0
        bottle.zPosition = 301
        bottle.name = "bottle"
        bottle.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        bottle.physicsBody?.dynamic = false
        bottle.physicsBody?.categoryBitMask = waterBottleCategory
        bottle.physicsBody?.collisionBitMask = 0
        self.addChild(bottle)
        // action for water bottle.
        let appear = SKAction.scaleTo(1.0, duration: 0.3)
        let wait = SKAction.waitForDuration(3.0)
        let disappear = SKAction.scaleTo(0.0, duration:0.5)
        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([appear, wait, disappear, remove])
        bottle.runAction(sequence)
    }
    
        func playerHitCar() {
           //take off lives here.
            println("player Hit Car")
            health -= 10
        }
        
        func playerHitBottle() {
            //self.bottle.removeFromParent()
            //add points or seconds.
            println("player Hit Bottle")
            if health >= 100 {
                 self.bottle.removeFromParent()
            } else {
                self.bottle.removeFromParent()
                health += 5
            }
        }
    
        func playerHitRoad() {
           //add points to total score here.
                println("player Hit Road")
            score += 25
        }
    
        func didBeginContact (contact: SKPhysicsContact) {

            let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
            if collision == playerCategory | carCategory {
            runDying()
            playerHitCar()
        }
            if collision == playerCategory | roadCategory {
            playerHitRoad()
        }
            if collision == playerCategory | waterBottleCategory {
            playerHitBottle()
                    //runSound
        }
  }
    
    func runDying() {
            let colorchange = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor:1.0, duration: 0.3)
            let blinkTimes = 10.0
            let duration = 3.0
            let blinkAction = SKAction.customActionWithDuration(duration) {
            node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime) % slice
            node.hidden = remainder > slice / 2
        }
    self.player.runAction(SKAction.sequence([colorchange, blinkAction]))
    }
    
    override func didEvaluateActions()   {
    boundsCheckPlayer()
        
    }
    
    func spawnEnemy() {
        let car = SKSpriteNode(imageNamed: "car")
        car.setScale(3.0)
        car.name = "enemy";
        car.position = CGPoint(
        x: size.width + car.size.width/2, y: CGFloat.random(
            min: CGRectGetMinY(playableRect) + car.size.height/2,
            max: CGRectGetMaxY(playableRect) - car.size.height/2))
        
        car.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(600, 200))
        car.physicsBody?.dynamic = true
        car.physicsBody?.restitution = 0.4
        car.physicsBody?.friction = 0.5
        car.physicsBody?.categoryBitMask = carCategory
        car.physicsBody?.collisionBitMask = playerCategory | skullCategory | baseCategory
        self.addChild(car)
        
        car.name = "car";
        let actionMove = SKAction.moveToX(-car.size.width/2, duration:1.7)
        let actionRemove = SKAction.removeFromParent()
        car.runAction(SKAction.sequence([actionMove, actionRemove]))
    }
    
    func spawnSkull() {
        let skull = SKSpriteNode(imageNamed: "Skull")
        skull.xScale = 2.5
        skull.yScale = 2.5
        skull.alpha = 0.5
        skull.name = "skull";
        skull.position = CGPoint(
            x: size.width + skull.size.width/2, y: CGFloat.random(
                min: CGRectGetMinY(playableRect) + skull.size.height/2,
                max: CGRectGetMaxY(playableRect) - skull.size.height/2))
        
        skull.physicsBody = SKPhysicsBody(circleOfRadius: 150)
        skull.physicsBody?.dynamic = true
        skull.physicsBody?.allowsRotation = true
        skull.physicsBody?.restitution = 1.0
        skull.physicsBody?.categoryBitMask = skullCategory
        skull.physicsBody?.collisionBitMask = carCategory | playerCategory | baseCategory
        self.addChild(skull)

        let actionMove = SKAction.moveToX(-skull.size.width/2, duration:1.9)
        let actionRemove = SKAction.removeFromParent()
        skull.runAction(SKAction.sequence([actionMove, actionRemove]))
    }
    
func createRoad() {
        //creating a empty node so we know when the bike touches the ground for scoring.
        var dummyRoadNode = SKNode()
        dummyRoadNode.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.15)
        dummyRoadNode.zPosition = -10
        dummyRoadNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.width, 200))
        dummyRoadNode.physicsBody?.restitution = 0.7
        dummyRoadNode.physicsBody?.dynamic = false
        dummyRoadNode.physicsBody?.categoryBitMask = roadCategory
        dummyRoadNode.physicsBody?.collisionBitMask = 0
        self.addChild(dummyRoadNode)
    }
    
     override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if (CGRectContainsPoint(frame, touchLocation)) {
            player.physicsBody?.velocity = CGVectorMake(0, 0)
            player.physicsBody?.applyImpulse(CGVectorMake(0, 270))
            if (gameOver == true) {
                beginButton()
            } else{
                //moveplayer()
                self.player.paused = false
                //self.player.flying = true
                //self.player.accelerating = true
               // player.notFlying = false
            }
        }
    }
}
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
            
        stopMovingPlayer()
        gameOver = false
        player.paused = true
       // self.player.accelerating = false
        //player.flying = false
        //player.notFlying = true
    }

    func moveplayer() {
        player.physicsBody?.velocity = CGVectorMake(-1, 0)
        player.physicsBody?.applyImpulse(CGVectorMake(0, 350))
    }
    
    func stopMovingPlayer() {
        player.physicsBody?.velocity = CGVectorMake(0, 0)
        player.physicsBody?.applyImpulse(CGVectorMake(0, 0))
    }
    
    override func update(currentTime: CFTimeInterval) {
        //timer from ios tutorial...
        self.currentTime = currentTime
        elapsedTime = currentTime - startTime
        var timeRemaining = levelTimeLimit - elapsedTime
                   
                if timeRemaining >= 0 {
                     timeLabel.text = NSString(format: "Time: %2.2f", timeRemaining)
            }
                if elapsedTime <= levelTimeLimit && timeRemaining <= 1 {
                        winMenu()
                    println("time is out")
            }
                if score >= 0 {
                    scoreLabel.text = "Score: \(score)"
            }
                if (gameOver == false && score >= 1000) {
                    winMenu()
                    //stop music
                    println("You Win!")
            }
                if (health <= 0) {
                    gameOverMenu()
                    //Stop music
                    println("you lost")
            }
        
        // update the color so that the closer to 0 it gets the more red it becomes
        healthMeterLabel.fontColor = SKColor(red: CGFloat(2.0 * (1 - self.health / 100)), green: CGFloat(2.0 * self.health / 100), blue: 0, alpha: 1)
        
        // Calculate the length of the players health bar.
        healthBarLength = Double(healthMeterText.length) * self.health / 100.0;
        healthMeterLabel.text = healthMeterText.substringToIndex(Int(healthBarLength))
        
        // If the player health reaches 0 then change the game state.
        if self.health <= 0 {
            //println("gameover")
            gameOver = true
        }
    }
    
    func gameOverMenu() {
//        self.enumerateChildNodesWithName("Skull", usingBlock: {
//    node, stop in
//        node.removeFromParent()
//    })
//        player.removeFromParent()
//        car.removeFromParent()
//        bottle.removeFromParent()
//        levelTimeLimit = 0.0
//        timeLabel.removeFromParent()
//        currentTime = 0.0
//        startTime = 0.0
//        elapsedTime = 0.0
//        
//        car.removeActionForKey("spawnEnemy")
//       
//        player.removeActionForKey("car")
//        bottle.removeActionForKey("spawnWaterBottle")
        
        //self.removeAllChildren()
        //self.removeAllActions()
        
        //turn music off.
        health = 0
        
        let wait = SKAction.waitForDuration(0.1)
        let block = SKAction.runBlock {
            let transition = SKTransition.flipHorizontalWithDuration(2.0)
            let scene = GameOverScene(size: self.size, won:false)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(scene, transition: transition)
        }
        let sequence = SKAction.sequence([block, wait])
        self.runAction(sequence)
        

        
    }
    
    func winMenu() {
//        self.enumerateChildNodesWithName("Skull", usingBlock: {
//        node, stop in
//        node.removeFromParent()
//        })
//        player.removeFromParent()
//        car.removeFromParent()
//        bottle.removeFromParent()
//        self.removeAllChildren()
        
        
        println("Winner!")
        let wait = SKAction.waitForDuration(0.1)
        let block = SKAction.runBlock {
            let transition = SKTransition.flipHorizontalWithDuration(1.0)
            let scene = GameOverScene(size: self.size, won:true)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(scene, transition: transition)
        }
        let sequence = SKAction.sequence([block, wait])
        self.runAction(sequence)
    }
    
    func boundsCheckPlayer() {
        let bottomLeft = CGPoint(x: 0,
        y: CGRectGetMinY(playableRect))
        let topRight = CGPoint(x: size.width,
        y: CGRectGetMaxY(playableRect))
        if player.position.x <= bottomLeft.x {
        player.position.x = bottomLeft.x
        velocity.x = -velocity.x
        }
        if player.position.x >= topRight.x {
        player.position.x = topRight.x
        velocity.x = -velocity.x }
        if player.position.y <= bottomLeft.y {
        player.position.y = bottomLeft.y
        velocity.y = -velocity.y
        }
        if player.position.y >= topRight.y {
        player.position.y = topRight.y
        velocity.y = -velocity.y }
    }
    
    func createPlayer() {
            player = SKSpriteNode(imageNamed: "Bike1")
            player.position = CGPointMake(self.size.width * 0.1, self.size.height * 0.8)
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
    }
    
 }