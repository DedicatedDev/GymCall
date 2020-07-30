//
//  User.swift
//  GymCall
//
//  Created by FreeBird on 6/16/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation

struct UserForRoom {
    let userName:String?
    let udid:String?
    let fcmToken:String?
    let imageLink:String?
    
    init(model:[String:Any]) {
        
        userName = model["userName"] as? String
        udid = model["udid"] as? String
        fcmToken = model["fcmToken"] as? String
        imageLink = model["imageLink"] as? String
    }
}

struct UserStatus{
    var meettingId:String?
    var currentActivityType:ActivityType?
    var currentStatus:PageType?
    var activityDuration:String?
    var youtubLink:String?
    var invitationMsg:String?
    mutating func register(activityType:String){
        currentActivityType = ActivityType(rawValue: activityType)
    }
}


