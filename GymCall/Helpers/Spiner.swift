//
//  Spiner.swift
//  BlueWave
//
//  Created by FreeBird on 5/10/20.
//  Copyright © 2020 SuccessResultSdnBhd. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class Spinner {
    internal static var hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    public static func start() {
        if let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first {
            hud.textLabel.text = nil
            hud.show(in: keyWindow, animated: true)
        }
    }
    public static func stop() {
        hud.dismiss()
    }
}
