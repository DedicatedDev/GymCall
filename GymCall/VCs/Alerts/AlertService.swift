//
//  AlertService.swift
//  GymCall
//
//  Created by FreeBird on 5/18/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation

class AlertService{
    
    static let shared  = AlertService()
    
    func alertIndicator()->IndicatorViewController{
    
        let alertVC = IndicatorViewController()
        return alertVC
    }
    
    func alertSelection()->StartAlertVC{
        
        let alertVC = StartAlertVC()
        return alertVC
    }
    
     func inviteFriend()->InviteVC{
           
           let alertVC = InviteVC()
           return alertVC
    }
    
    func alertJoinIndicator() -> JoinIndicatorViewController{
        let alertVC = JoinIndicatorViewController()
        return alertVC
    }
    
}
