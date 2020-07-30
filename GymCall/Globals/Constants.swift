//
//  Constants.swift
//  GymCall
//
//  Created by FreeBird on 5/15/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import UIKit
struct MainColors {
    
    static let  BtnColor = UIColor(hexString: "#FD7028")
}

struct FontNames{
    static let OpenSansLight:String = "OpenSans-Light"
    static let OpenSansBold:String = "OpenSans-Bold"
    static let OpenSansExtraBold:String = "OpenSans-ExtraBold"
    static let OpenSansSemiBold:String = "OpenSans-SemiBold"
    static let OpenSansRegular:String = "OpenSans-Regular"
}

struct DataBasePath{
    
    static let profileImgFolder:String = "usersImage"
}
var currentUserInfo:UserMainInfo?
var myRoomId:String = ""

struct AppConfiguration {
    static let url = "https://5mh9axvhgd.execute-api.us-east-1.amazonaws.com/Prod/"
    static let region = "us-east-1"
}

var myStatus = UserStatus()
var activityProgress:ActivityProgress = .inProgress
enum StepTime:Int {
    case search = 13
    case hi = 5
    case ready = 10
}

enum ActivityProgress:String{
    case waiting
    case ready
    case start
    case inProgress
    case playEnd
    case exitActivity
}

enum memberStatus:String {
    case initial = "Random"
    case none = "No Match"
    case leave = "Go off"
}

