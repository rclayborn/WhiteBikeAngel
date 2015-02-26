//
//  GameViewController.swift
//  WhiteBikeAngel
//
//  Created by Randall Clayborn on 2/11/15.
//  Copyright (c) 2015 claybear39. All rights reserved.
//

import UIKit
import SpriteKit
import Social
import iAd
import GameKit

class GameViewController: UIViewController,  ADBannerViewDelegate, GKGameCenterControllerDelegate {
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    var score: Int = 0
    
    override func viewDidLoad() {
          self.authenticateLocalPlayer()
        
    let scene = WBAMainMenu(size:CGSize(width: 2048, height: 1536))
    let skView = self.view as SKView
    //skView.showsFPS = true
    //skView.showsPhysics = true
    //skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .AspectFill
    skView.presentScene(scene)
        
        //display iAd at bottom of scene.
        moveADBannerToViewController(self, atPosition: .Bottom)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTweetSheet", name: "CallTheNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showFBSheet", name: "CallTheFacebook", object: nil)
    }
    
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.presentViewController(ViewController, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                println("Local player already authenticated")
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer
                    }
                })
                
            } else {
                self.gcEnabled = false
                println("Local player could not be authenticated, disabling game center")
                println(error)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showLeaderboard() {
        var gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "WBA_Leader_board"
        self.presentViewController(gcVC, animated: true, completion: nil)
    
    }
    
    override func viewDidAppear(animated: Bool) {
        // Create down menu button
        var homeLabel = self.createHomeButtonView()
        
        var downMenuButton = BubbleMenuButton(frame: CGRectMake(20.0,
            20.0,
            homeLabel.frame.size.width,
            homeLabel.frame.size.height), expansionDirection: ExpansionDirection.DirectionDown)
        downMenuButton.homeButtonView = homeLabel;
        downMenuButton.addButtons(self.createDemoButtonArray())
        self.view.addSubview(downMenuButton)
    }
    
    func createHomeButtonView() -> UILabel {
        
        var label = UILabel(frame: CGRectMake(0.0, 0.0, 40.0, 40.0))
        
        label.text = "Tap";
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.layer.cornerRadius = label.frame.size.height / 16.0;
        label.backgroundColor = UIColor(red:0.0,green:0.0,blue:0.0,alpha:0.5)
        label.clipsToBounds = true;
        
        return label;
    }
    
    func createDemoButtonArray() -> [UIButton] {
        var buttons:[UIButton]=[]
        var i = 0
        for str in ["Play","CG","HOW","ETC"] {
            var button:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitle(str, forState: UIControlState.Normal)
            
            button.frame = CGRectMake(0.0, 0.0, 100.0, 60.0);
            button.layer.cornerRadius = button.frame.size.height / 2.0;
            button.backgroundColor = UIColor(red: 0.3, green: 0.0, blue: 0.0, alpha: 0.5)
            button.clipsToBounds = true;
            button.tag = i++;
            button.addTarget(self, action: Selector("buttonTap:"), forControlEvents: UIControlEvents.TouchUpInside)
            buttons.append(button)
        }
        return buttons
    }
    
    func createButtonWithName(imageName:NSString) -> UIButton {
        var button = UIButton()
        
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.sizeToFit()
        button.addTarget(self, action: Selector("buttonTap:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }
    
    func buttonTap(sender:UIButton){
        
        //println("Button tapped, tag:\(sender.tag)")
        if sender.tag == 0 {
            let scene = WBAGamePlayScene(size: CGSize(width: 2048, height: 1536))
            // Configure the view.
            let skView = self.view as SKView
            // skView.showsFPS = true
            //skView.showsNodeCount = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        if sender.tag == 1 {
            showLeaderboard()
        }
        if sender.tag == 2 {
            let scene = WhatScene(size: CGSize(width: 2048, height: 1536))
            // Configure the view.
            let skView = self.view as SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        if sender.tag == 3 {
            let scene = WhyScene(size: CGSize(width: 2048, height: 1536))
            // Configure the view.
            let skView = self.view as SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    
    func showTweetSheet() {
        let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweetSheet.completionHandler = {
            result in
            switch result {
            case SLComposeViewControllerResult.Cancelled:
                //Add code to deal with it being cancelled
                break
                
            case SLComposeViewControllerResult.Done:
                //Add code here to deal with it being completed
                //Remember that dimissing the view is done for you, and sending the tweet to social media is automatic too. You could use this to give in game rewards?
                break
            }
        }
        
        tweetSheet.setInitialText("Test Twitter") //The default text in the tweet
        tweetSheet.addImage(UIImage(named: "bottle.png")) //Add an image if you like?
        tweetSheet.addURL(NSURL(string: "http://twitter.com")) //A url which takes you into safari if tapped on
        
        self.presentViewController(tweetSheet, animated: false, completion: {
            //Optional completion statement
        })
    }
    
    func showFBSheet() {
        let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        fbSheet.completionHandler = {
            result in
            switch result {
            case SLComposeViewControllerResult.Cancelled:
                //Add code to deal with it being cancelled
                break
                
            case SLComposeViewControllerResult.Done:
                //Add code here to deal with it being completed
                //Remember that dimissing the view is done for you, and sending the tweet to social media is automatic too. You could use this to give in game rewards?
                break
            }
        }
        
        fbSheet.setInitialText("Test Facebook") //The default text in the tweet
        fbSheet.addImage(UIImage(named: "bottle.png")) //Add an image if you like?
        fbSheet.addURL(NSURL(string: "http://facebook.com")) //A url which takes you into safari if tapped on
        
        self.presentViewController(fbSheet, animated: false, completion: {
            //Optional completion statement
        })
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

  override func supportedInterfaceOrientations() -> Int {
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
