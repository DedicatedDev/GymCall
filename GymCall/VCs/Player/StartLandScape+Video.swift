//
//  StartLandScape+Video.swift
//  GymCall
//
//  Created by FreeBird on 6/20/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import UIKit
import  XCDYouTubeKit

extension StartLandscapeVC{
    
    
    func getParseURL(id:String,completion:@escaping(Result<URL,PlayerError>)->()){
       print(id)
           XCDYouTubeClient.default().getVideoWithIdentifier(id) { (video, err) in
               if err != nil {
                   print("okay")
                completion(.failure(.parseFailed))
                return
               }else{
                completion(.success(video!.streamURL))
                return
               }
           }
           
       }
       
       func getYoutubeId(youtubeUrl: String) -> String? {
        
        
        if  youtubeUrl.contains("?v="){
            return  (URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value)! as String
        }else{
            guard let id = youtubeUrl.split(separator: "/").last else{
                return nil
            }
            
            return String(id)
        }
    }
    
//    func createSpinnerView() {
//        
//        addChild(GymIndicator.shared)
//        GymIndicator.shared.view.frame = CGRect(x: view.bounds.width/2 - 15,y: view.bounds.width/2 - 15, width: 30, height: 30)
//        view.addSubview(GymIndicator.shared.view)
//        GymIndicator.shared.didMove(toParent: self)
//        
//        // wait two seconds to simulate some work happening
//    }
//    
//    func removeSpinnerView(){
//        DispatchQueue.main.async {
//             GymIndicator.shared.willMove(toParent: nil)
//             GymIndicator.shared.view.removeFromSuperview()
//             GymIndicator.shared.removeFromParent()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
//             // then remove the spinner view controller
//            GymIndicator.shared.willMove(toParent: nil)
//            GymIndicator.shared.view.removeFromSuperview()
//            GymIndicator.shared.removeFromParent()
//         }
//    }
    
}
