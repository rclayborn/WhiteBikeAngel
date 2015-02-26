//
//  Global_iAd.swift
//  ArmpitTour1.2
//
//  Created by Randall Clayborn on 1/27/15.
//  Copyright (c) 2015 claybear39. All rights reserved.
//

import UiKit
import iAd

public enum ADBAnnerPosition {
    case Top
    case Bottom
}

public func moveADBannerToViewController(viewController: UIViewController, atPosition position: ADBAnnerPosition) {
    sharedADBannerView.removeFromSuperview()
    let view = viewController.view
    
    view.addSubview(sharedADBannerView)
    
    let visualDictionary = [
        "banner" : sharedADBannerView
    ]
    
    let margin = (position == .Top) ? viewController.topLayoutGuide.length : viewController.bottomLayoutGuide.length
    
    let verticalFormat = (position == .Top) ? "V:|-(\(margin))-[banner]" : "V:[banner]-(\(margin))-|"
    let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
        verticalFormat,
        options: NSLayoutFormatOptions.allZeros,
        metrics: nil,
        views: visualDictionary)
    
    let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
        "|-0-[banner]-0-|",
        options: NSLayoutFormatOptions.allZeros,
        metrics: nil,
        views: visualDictionary)
    
    view.addConstraints(verticalConstraints + horizontalConstraints)
}

// The banner singleton
private let sharedADBannerView: ADBannerView = {
    let b = ADBannerView(adType: ADAdType.Banner)
    b.setTranslatesAutoresizingMaskIntoConstraints(false)
    b.hidden = true
    b.delegate = b
    return b
    }()

// The ADBannerView can be delegate of itself
//  and just hide or show the banner
extension ADBannerView: ADBannerViewDelegate {
    
    public func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        if banner === self {
            self.hidden = true
        }
    }
    
    public func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    public func bannerViewDidLoadAd(banner: ADBannerView!) {
        if banner === self {
            self.hidden = false
        }
    }
}
