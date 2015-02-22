//
//  HighScore.swift
//  highScoreNSArchive
//
//  Created by Randall Clayborn on 12/9/14.
//  Copyright (c) 2014 claybear39. All rights reserved.
//

import Foundation

class HighScore: NSObject {
    
    var highScore: Int = 0
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeInteger(highScore, forKey: "highScore")
    }
    
    init(coder aDecoder: NSCoder!) {
        highScore = aDecoder.decodeIntegerForKey("highScore")
    }
    
    override init() {
    }
}

class SaveHighScore:NSObject {
    
    var documentDirectories:NSArray = []
    var documentDirectory:String = ""
    var path:String = ""
    
    func ArchiveHighScore(#highScore: HighScore) {
        documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        documentDirectory = documentDirectories.objectAtIndex(0) as String
        path = documentDirectory.stringByAppendingPathComponent("highScore.archive")
        
        if NSKeyedArchiver.archiveRootObject(highScore, toFile: path) {
            //println("Success writing to file!")
        } else {
            //println("Unable to write to file!")
        }
    }
    
    func RetrieveHighScore() -> NSObject {
        var dataToRetrieve = HighScore()
        documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        documentDirectory = documentDirectories.objectAtIndex(0) as String
        path = documentDirectory.stringByAppendingPathComponent("highScore.archive")
        if let dataToRetrieve2 = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? HighScore {
            dataToRetrieve = dataToRetrieve2
        }
        return(dataToRetrieve)
    }
}