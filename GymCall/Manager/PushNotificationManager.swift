//
//  PushNotificationManager.swift
//  BlueWave
//
//  Created by FreeBird on 4/25/20.
//  Copyright © 2020 SuccessResultSdnBhd. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let userID: String
    init(userID: String) {
        self.userID = userID
        super.init()
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self

        } else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert,.badge ,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("users").document(userID)
            usersRef.setData(["fcmToken": token], merge: true)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateFirestorePushTokenIfNeeded()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let title = response.notification.request.content.title
        let category = response.notification.request.content.categoryIdentifier
        let content = response.notification.request.content.body
        
        let inviteId = userInfo["senderId"] as? String
        let youtubLink = userInfo["videoLink"] as? String
        
        if inviteId != nil {
            if !inviteId!.isEmpty{
                UserDefaults.standard.setValue(PageType.inviteActivity.rawValue, forKey: "pageType" )
                let vc = JoinStartActivityVC()
                myStatus.invitationMsg = content
                myStatus.meettingId = inviteId
                myStatus.currentStatus = .inviteActivity
                myStatus.youtubLink = youtubLink
                Utils.shared.rootViewController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc = RootVC()
            myStatus.invitationMsg = content
            myStatus.meettingId = inviteId
            myStatus.currentStatus = .inviteActivity
            myStatus.youtubLink = youtubLink
            Utils.shared.rootViewController?.pushViewController(vc, animated: true)
        }

        
        
        
        switch UIApplication.shared.applicationState {
        case .inactive, .background:

            if category == "recent" {
                UserDefaults.standard.set(true, forKey: "badgeCount")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecentUpdate"), object: title, userInfo: userInfo)
            }
            print(userInfo)
        default:

            if category == "recent" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecentUpdate"), object: title, userInfo: userInfo)
            }
            print(userInfo)
            break
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
