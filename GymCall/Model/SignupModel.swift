//
//  SignupModel.swift
//  GymCall
//
//  Created by FreeBird on 5/24/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import AmazonChimeSDK

struct UserMainInfo:Codable{
    
    let fullName:String
    let userName:String
    let goal:String
    let age:String
    let weight:String
    let email:String
    let imageLink:String

}

public class RosterAttendee {
    let attendeeId: String
    let attendeeName: String?
    var volume: VolumeLevel
    var signal: SignalStrength

    init(attendeeId: String, attendeeName: String, volume: VolumeLevel, signal: SignalStrength) {
        self.attendeeId = attendeeId
        self.attendeeName = attendeeName
        self.volume = volume
        self.signal = signal
    }
}
