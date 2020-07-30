//
//  Utils.swift
//  GymCall
//
//  Created by FreeBird on 5/24/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import FirebaseAuth

class Utils: NSObject {
    
    static let shared = Utils()
    var rootViewController:UINavigationController?
    static func FirebaseErrAnalysis(err:Error?)->String{
    var firebaseErrorMsgTxt: String = "Failed!"
    if let errCode = AuthErrorCode(rawValue: err!._code) {

         switch errCode {
         case .emailAlreadyInUse:
              firebaseErrorMsgTxt = "This email was used by others"
         case .invalidEmail:
              firebaseErrorMsgTxt = "Invalid email"
         case.wrongPassword:
              firebaseErrorMsgTxt = "Wrong Password!"
         case.weakPassword:
              firebaseErrorMsgTxt = "Password needs to be more than six charactors!"
         case.tooManyRequests:
              firebaseErrorMsgTxt = "Too many try. Please try again later"
         case.userNotFound:
              firebaseErrorMsgTxt = "Please input correct email address!"
             default:
              print("Create User Error: \(String(describing: err))")
         }
    
     }
  
     return firebaseErrorMsgTxt
    }
    
    
}
