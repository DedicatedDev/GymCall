//
//  Room.swift
//  GymCall
//
//  Created by FreeBird on 6/16/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation

struct Room : Codable{
    let activityType:String?
    let master:String?
    let activityStatus:String?
    let activityDuration:String?
    let members:Members?
}

struct Members :Codable{
    let a:Member?
    let b:Member?
    let c:Member?
    let d:Member?
}

struct Member : Codable {
    let id:String?
    let userName:String?
    let token:String?
    
    init(model:UserForRoom) {
        userName = model.userName
        id = model.udid
        token = model.fcmToken
    }
    init() {
        userName = ""
        id = ""
        token = ""
    }
}
