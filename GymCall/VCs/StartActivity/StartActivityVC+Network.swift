//
//  StartActivityVC.swift
//  GymCall
//
//  Created by FreeBird on 6/12/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import UIKit

//extension StartActivityVC{
            
    //        meetingID = meetingIDText.text ?? ""
            
    //        name = nameText.text ?? ""
            
    //        joinButton.isEnabled = false
//    func postRequest(completion: { data, error in
//                guard error == nil else {
//                    DispatchQueue.main.async {
//                        self.view.makeToast("Unable to join meeting please try different meeting ID", duration: 2.0)
//    //                    self.joinButton.isEnabled = true
//                    }
//                    return
//                }
//
//                if let data = data {
//                    let (meetingResp, attendeeResp) = self.processJson(data: data)
//                    guard let currentMeetingResponse = meetingResp, let currentAttendeeResponse = attendeeResp else {
//                        return
//                    }
//
//                    let meetingSessionConfig = MeetingSessionConfiguration(createMeetingResponse: currentMeetingResponse,
//                                                                           createAttendeeResponse: currentAttendeeResponse,
//                                                                           urlRewriter: self.urlRewriter)
    //                DispatchQueue.main.async {
    //                    let meetingView = UIStoryboard(name: "Main", bundle: nil)
    //                    guard let meetingViewController = meetingView.instantiateViewController(withIdentifier: "meeting")
    //                        as? MeetingViewController else {
    //                            self.logger.error(msg: "Unable to instantitateViewController")
    //                            return
    //                    }
    //                    meetingViewController.modalPresentationStyle = .fullScreen
    //                    meetingViewController.meetingSessionConfig = meetingSessionConfig
    //                    meetingViewController.meetingId = self.meetingID
    //                    meetingViewController.selfName = self.name
    //                    self.present(meetingViewController, animated: true, completion: nil)
    //                }
//                }
//            })
//
//
//        }
//
//        private func urlRewriter(url: String) -> String {
//            // changing url
//            // return url.replacingOccurrences(of: "example.com", with: "my.example.com")
//            return url
//        }
        
     //   private func postRequest(completion: @escaping CompletionFunc) {
    //        if meetingID.isEmpty || name.isEmpty {
    //            DispatchQueue.main.async {
    //                self.view.makeToast("Given empty meetingID or name please provide those values", duration: 2.0)
    //            }
    //            return
    //        }

//            let encodedURL = HttpUtils.encodeStrForURL(
//                str: "\(AppConfiguration.url)join?title=\(meetingID)&name=\(name)&region=\(AppConfiguration.region)"
//            )
//            HttpUtils.postRequest(
//                url: encodedURL,
//                completion: completion,
//                jsonData: nil, logger: logger
//            )
//        }
//
//        private func processJson(data: Data) -> (CreateMeetingResponse?, CreateAttendeeResponse?) {
//            let jsonDecoder = JSONDecoder()
//            do {
//                let joinMeetingResponse = try jsonDecoder.decode(JoinMeetingResponse.self, from: data)
//                let meetingResp = CreateMeetingResponse(meeting:
//                    Meeting(
//                        externalMeetingId: joinMeetingResponse.joinInfo.meeting.meeting.externalMeetingId,
//                        mediaPlacement: MediaPlacement(
//                            audioFallbackUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.audioFallbackUrl,
//                            audioHostUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.audioHostUrl,
//                            signalingUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.signalingUrl,
//                            turnControlUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.turnControlUrl
//                        ),
//                        mediaRegion: joinMeetingResponse.joinInfo.meeting.meeting.mediaRegion,
//                        meetingId: joinMeetingResponse.joinInfo.meeting.meeting.meetingId
//                    )
//                )
//                let attendeeResp = CreateAttendeeResponse(attendee:
//                    Attendee(attendeeId: joinMeetingResponse.joinInfo.attendee.attendee.attendeeId,
//                             externalUserId: joinMeetingResponse.joinInfo.attendee.attendee.externalUserId,
//                             joinToken: joinMeetingResponse.joinInfo.attendee.attendee.joinToken))
//
//                return (meetingResp, attendeeResp)
//            } catch {
//                logger.error(msg: error.localizedDescription)
//                return (nil, nil)
//            }
//        }
//
//}
