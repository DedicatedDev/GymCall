//
//  StreamingManager.swift
//  GymCall
//
//  Created by FreeBird on 6/16/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import AmazonChimeSDK
import AVFoundation
import AVKit
import FirebaseAuth
import FirebaseDatabase
class StreamingManager: NSObject {
    
    
    static let shared = StreamingManager()
    
    var isStartMeeting:Bool = false
    var isMuted = false {
        didSet {
            if isMuted {
                if (self.currentMeetingSession?.audioVideo.realtimeLocalMute()) ?? false {
                    logger.info(msg: "Microphone has been muted")
                }
            } else {
                if (self.currentMeetingSession?.audioVideo.realtimeLocalUnmute()) ?? false {
                    logger.info(msg: "Microphone has been unmuted")
                }
            }
        }
    }
    
    var managedView = UIView()
    let logger = ConsoleLogger(name: "StartActivityVC")
    
    ///video parameteres//
    let maxVideoTileCount = 4
    var currentMeetingSession: MeetingSession?
    
    var videoTiles:[DefaultVideoRenderView] = []{
        didSet{
            if !videoTiles.isEmpty{
                showInViews(with: videoTiles)
            }
        }
    }
    var videoTileStates: [VideoTileState?] = [nil] {
        didSet{
            videoTileStatesForDisplay = ArraySlice.init(repeating: nil, count: videoTileStates.count)
           
        }
    }

    var videoTileStatesForDisplay: ArraySlice<VideoTileState?> = ArraySlice.init(repeating: nil, count: 1) {
        didSet{
            
            if !videoTiles.isEmpty{
                showInViews(with: videoTiles)
            }
        }
    }
    
    
    public var meetingSessionConfig: MeetingSessionConfiguration?
    let uuid = UUID().uuidString
    var currentRoster = [String: RosterAttendee]()
    var attendees = [RosterAttendee]()
    let contentDelimiter = "#content"
    let contentSuffix = "<<Content>>"
    var activeSpeakerIds: [String] = []
    
    /////
    
    func showInViews(with videoTiles:[DefaultVideoRenderView]){
        
        let endIndex = videoTileStatesForDisplay.count - 1
        for i in 0...endIndex{
            videoTiles[i].mirror = false
            if let tileState = self.videoTileStatesForDisplay[i]{
                if let view = videoTiles[i].superview as? StreamingView{
                    view.placeholer = ""
                }
                if tileState.isLocalTile{
                    if self.currentMeetingSession?.audioVideo.getActiveCamera()?.type == .videoFrontCamera {
                        videoTiles[i].mirror = true
                    }
                }
                
                print(videoTileStates[i]?.videoStreamContentWidth ?? 0)
                print(videoTileStates[i]?.videoStreamContentHeight ?? 0)
 
                
                self.currentMeetingSession?.audioVideo.bindVideoView(
                    videoView: videoTiles[i],
                    tileId: tileState.tileId)
            }
        }
        
        for i in endIndex+1 ... 3 {
            videoTiles[i].mirror = false
            if let view = videoTiles[i].superview as? StreamingView{
                if isStartMeeting{
                     view.placeholer = "No Match"
                }else{
                     view.placeholer = "Random"
                }
            }
        }
        
    }

    func resetManager(){
        videoTiles = []
        videoTileStates = [nil]
        videoTileStatesForDisplay = ArraySlice.init(repeating: nil, count: 1)
    }
    
    func createMyRoom(with members:Members?){
        
        let roomData = Room(activityType: myStatus.currentActivityType?.rawValue, master: Auth.auth().currentUser?.uid, activityStatus: ActivityProgress.waiting.rawValue, activityDuration: myStatus.activityDuration, members: members)
        
        NetWorkManager.shared.creatRoom(with: roomData ) { (result) in
            switch result{
            case .success(let response):
                print(response)
                myRoomId = response
                myStatus.meettingId = myRoomId
                self.createMeeting(with: myRoomId)
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
        
        NetWorkManager.shared.registerJoinedFlag(with: true) { (result) in
            print("in progress")
        }
    }
    
    func createMeeting(with id:String){
        
        postRequest(with: id, completion: { data, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.managedView.makeToast("Unable to join meeting please try different meeting ID", duration: 2.0)
                }
                return
            }
            
            if let data = data {
                let (meetingResp, attendeeResp) = self.processJson(data: data)
                guard let currentMeetingResponse = meetingResp, let currentAttendeeResponse = attendeeResp else {
                    return
                }
                
                let meetingSessionConfig = MeetingSessionConfiguration(createMeetingResponse: currentMeetingResponse,createAttendeeResponse: currentAttendeeResponse,                                 urlRewriter: self.urlRewriter)
                self.isStartMeeting = true
                DispatchQueue.global(qos: .background).async {
                    self.currentMeetingSession = DefaultMeetingSession(
                        configuration: meetingSessionConfig, logger: self.logger)
                    self.setupAudioEnv()
                    self.setupVideoEnv()
                    self.currentMeetingSession?.audioVideo.startRemoteVideo()
                }
            }
        })
    }
    
    
    
    func urlRewriter(url: String) -> String {
        // changing url
        // return url.replacingOccurrences(of: "example.com", with: "my.example.com")
        return url
    }
    
    func postRequest(with meetingId:String,completion: @escaping CompletionFunc) {
        
        let name = UUID.init().uuidString
        let encodedURL = HttpUtils.encodeStrForURL(
            str: "\(AppConfiguration.url)join?title=\(meetingId)&name=\(name)&region=\(AppConfiguration.region)"
        )
        HttpUtils.postRequest(
            url: encodedURL,
            completion: completion,
            jsonData: nil, logger: logger
        )
    }
    
    func processJson(data: Data) -> (CreateMeetingResponse?, CreateAttendeeResponse?) {
        let jsonDecoder = JSONDecoder()
        do {
            let joinMeetingResponse = try jsonDecoder.decode(JoinMeetingResponse.self, from: data)
            let meetingResp = CreateMeetingResponse(meeting:
                Meeting(
                    externalMeetingId: joinMeetingResponse.joinInfo.meeting.meeting.externalMeetingId,
                    mediaPlacement: MediaPlacement(
                        audioFallbackUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.audioFallbackUrl,
                        audioHostUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.audioHostUrl,
                        signalingUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.signalingUrl,
                        turnControlUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.turnControlUrl
                    ),
                    mediaRegion: joinMeetingResponse.joinInfo.meeting.meeting.mediaRegion,
                    meetingId: joinMeetingResponse.joinInfo.meeting.meeting.meetingId
                )
            )
            let attendeeResp = CreateAttendeeResponse(attendee:
                Attendee(attendeeId: joinMeetingResponse.joinInfo.attendee.attendee.attendeeId,
                         externalUserId: joinMeetingResponse.joinInfo.attendee.attendee.externalUserId,
                         joinToken: joinMeetingResponse.joinInfo.attendee.attendee.joinToken))
            
            return (meetingResp, attendeeResp)
        } catch {
            logger.error(msg: error.localizedDescription)
            return (nil, nil)
        }
    }
    
    
    func setupAudioEnv() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options:
                AVAudioSession.CategoryOptions.allowBluetooth)
            self.setupSubscriptionToAttendeeChangeHandler()
            try self.currentMeetingSession?.audioVideo.start(callKitEnabled: false)
        } catch PermissionError.audioPermissionError {
            let audioPermission = AVAudioSession.sharedInstance().recordPermission
            if audioPermission == .denied {
                self.logger.error(msg: "User did not grant audio permission, it should redirect to Settings")
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    if granted {
                        self.setupAudioEnv()
                    } else {
                        self.logger.error(msg: "User did not grant audio permission")
                    }
                }
            }
        } catch {
            self.logger.error(msg: "Error starting the Meeting: \(error.localizedDescription)")
            self.leaveMeeting()
        }
    }
    
    
    func setupVideoEnv() {
        
        do {
            try self.currentMeetingSession?.audioVideo.startLocalVideo()
        } catch PermissionError.videoPermissionError {
            let videoPermission = AVCaptureDevice.authorizationStatus(for: .video)
            if videoPermission == .denied {
                self.logger.error(msg: "User did not grant video permission, it should redirect to Settings")
                self.notify(msg: "You did not grant video permission, Please go to Settings and change it")
            } else {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setupVideoEnv()
                    } else {
                        self.logger.error(msg: "User did not grant video permission")
                        self.notify(msg: "You did not grant video permission, Please go to Settings and change it")
                    }
                }
            }
        } catch {
            self.logger.error(msg: "Error starting the Meeting: \(error.localizedDescription)")
            self.leaveMeeting()
        }
    }
    
    private func notify(msg: String) {
        self.logger.info(msg: msg)
        managedView.makeToast(msg, duration: 2.0)
    }
    
    func leaveMeeting() {
        
        self.currentMeetingSession?.audioVideo.stop()
        removeSubscriptionToAttendeeChangeHandler()
        isStartMeeting = false
    }
    
    
    func removeSubscriptionToAttendeeChangeHandler () {
        
        self.currentMeetingSession?.audioVideo.removeVideoTileObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeRealtimeObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeAudioVideoObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeMetricsObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeDeviceChangeObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeActiveSpeakerObserver(observer: self)
    }
    
    func setupSubscriptionToAttendeeChangeHandler() {
        
        self.currentMeetingSession?.audioVideo.addVideoTileObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addRealtimeObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addAudioVideoObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addMetricsObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addDeviceChangeObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addActiveSpeakerObserver(policy: DefaultActiveSpeakerPolicy(),
                                                                        observer: self)
    }
    
}


extension StreamingManager:VideoTileObserver{
    func videoTileSizeDidChange(tileState: VideoTileState) {
        print("okay")
    }
    
    
    func videoTileDidAdd(tileState: VideoTileState) {
        
        if tileState.isLocalTile {
            self.videoTileStates[0] = tileState
        } else {
            self.videoTileStates.append(tileState)
        }
        self.videoTileStatesForDisplay = self.videoTileStates[...self.getMaxIndexOfVisibleVideoTiles()]
        
    }
    
    
    func videoTileDidRemove(tileState: VideoTileState) {
        self.logger.info(msg: "Removing Video Tile tileId: \(tileState.tileId)" +
            " attendeeId: \(String(describing: tileState.attendeeId))")
        self.currentMeetingSession?.audioVideo.unbindVideoView(tileId: tileState.tileId)
        
        if tileState.isLocalTile {
            self.videoTileStates[0] = nil
        } else {
            if let tileStateIndex = self.videoTileStates.firstIndex(of: tileState) {
                self.videoTileStates.remove(at: tileStateIndex)
            }
        }
        
        self.videoTileStatesForDisplay = self.videoTileStates[...self.getMaxIndexOfVisibleVideoTiles()]
    }
    
    func videoTileDidPause(tileState: VideoTileState) {
        let attendeeId = tileState.attendeeId ?? "unkown"
        if tileState.pauseState == .pausedForPoorConnection {
            managedView.makeToast("Video for attendee \(attendeeId) " +
                " has been paused for poor network connection," +
                " video will automatically resume when connection improves")
        } else {
            managedView.makeToast("Video for attendee \(attendeeId) " +
                " has been paused")
        }
    }
    
    func videoTileDidResume(tileState: VideoTileState) {
        let attendeeId = tileState.attendeeId ?? "unkown"
        managedView.makeToast("Video for attendee \(attendeeId) has been unpaused")
    }
    
    func getMaxIndexOfVisibleVideoTiles() -> Int {
        // If local video was not enabled, we can show one more remote video
        let maxRemoteVideoTileCount = self.maxVideoTileCount - (self.videoTileStates[0] == nil ? 0 : 1)
        return min(maxRemoteVideoTileCount, self.videoTileStates.count - 1)
    }
    
    
    
}


extension StreamingManager:AudioVideoObserver{
    func audioSessionDidStartConnecting(reconnecting: Bool) {
        self.notify(msg: "Audio started connecting. Reconnecting: \(reconnecting)")
    }
    
    func audioSessionDidStart(reconnecting: Bool) {
        self.notify(msg: "Audio successfully started. Reconnecting: \(reconnecting)")
    }
    
    func audioSessionDidDrop() {
        self.notify(msg: "Audio Session Dropped")
    }
    
    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        self.logger.info(msg: "Audio stopped for a reason: \(sessionStatus.statusCode)")
        if sessionStatus.statusCode != .ok {
            self.leaveMeeting()
        }
    }
    
    func audioSessionDidCancelReconnect() {
        self.notify(msg: "Audio cancelled reconnecting")
    }
    
    func connectionDidRecover() {
        self.logger.info(msg: "Video connecting")
    }
    
    func connectionDidBecomePoor() {
        self.logger.info(msg: "Signal is poor")    }
    
    func videoSessionDidStartConnecting() {
        self.logger.info(msg: "Video connecting")
    }
    
    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        switch sessionStatus.statusCode {
        case .videoAtCapacityViewOnly:
            self.notify(msg: "Maximum concurrent video limit reached! Failed to start local video.")
        default:
            self.logger.info(msg: "Video started \(sessionStatus.statusCode)")
        }
    }
    
    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        print("okay")
    }
    
    
}

extension StreamingManager:RealtimeObserver{
    
    private func removeAttendeesAndReload(attendeeInfo: [AttendeeInfo]) {
        for currentAttendeeInfo in attendeeInfo {
            self.currentRoster.removeValue(forKey: currentAttendeeInfo.attendeeId)
        }
        self.attendees = self.currentRoster.values.sorted(by: {
            if let name0 = $0.attendeeName, let name1 = $1.attendeeName {
                return name0 < name1
            }
            return false
        })
        
    }
    
    private func logAttendee(attendeeInfo: [AttendeeInfo], action: String) {
        for currentAttendeeInfo in attendeeInfo {
            let attendeeId = currentAttendeeInfo.attendeeId
            guard let attendee = self.currentRoster[attendeeId] else {
                self.logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)" +
                    " external user id \(currentAttendeeInfo.externalUserId): \(action)")
                continue
            }
            self.logger.info(msg: "\(attendee.attendeeName ?? "nil"): \(action)")
        }
    }
    
    private func getAttendeeName(_ info: AttendeeInfo) -> String {
        let externalUserIdArray = info.externalUserId.components(separatedBy: "#")
        let attendeeName: String = externalUserIdArray[1]
        return info.attendeeId.hasSuffix(self.contentDelimiter) ? "\(attendeeName) \(self.contentSuffix)" : attendeeName
    }
    
    
    func volumeDidChange(volumeUpdates: [VolumeUpdate]) {
        for currentVolumeUpdate in volumeUpdates {
            let attendeeId = currentVolumeUpdate.attendeeInfo.attendeeId
            guard let attendee = self.currentRoster[attendeeId] else {
                self.logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)" +
                    " external user id \(currentVolumeUpdate.attendeeInfo.externalUserId)")
                continue
            }
            let volume = currentVolumeUpdate.volumeLevel
            if attendee.volume != volume {
                attendee.volume = volume
                if let name = attendee.attendeeName {
                    self.logger.info(msg: "Volume changed for \(name): \(volume)")
                }
            }
        }
    }
    
    func signalStrengthDidChange(signalUpdates: [SignalUpdate]) {
        for currentSignalUpdate in signalUpdates {
            let attendeeId = currentSignalUpdate.attendeeInfo.attendeeId
            guard let attendee = self.currentRoster[attendeeId] else {
                self.logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)" +
                    " external user id \(currentSignalUpdate.attendeeInfo.externalUserId)")
                continue
            }
            let signal = currentSignalUpdate.signalStrength
            if attendee.signal != signal {
                attendee.signal = signal
                if let name = attendee.attendeeName {
                    self.logger.info(msg: "Signal strength changed for \(name): \(signal)")
                }
            }
        }
    }
    
    func attendeesDidJoin(attendeeInfo: [AttendeeInfo]) {
        var updateRoster = [String: RosterAttendee]()
        for currentAttendeeInfo in attendeeInfo {
            let attendeeId = currentAttendeeInfo.attendeeId
            let attendeeName = self.getAttendeeName(currentAttendeeInfo)
            if let attendee = self.currentRoster[attendeeId] {
                updateRoster[attendeeId] = attendee
            } else {
                updateRoster[attendeeId] = RosterAttendee(
                    attendeeId: attendeeId, attendeeName: attendeeName, volume: .notSpeaking, signal: .high)
            }
        }
        
        for (attendeeId, attendee) in updateRoster {
            self.currentRoster[attendeeId] = attendee
            self.attendees.append(attendee)
            print(attendees)
        }
        
    }
    
    
    
    func attendeesDidLeave(attendeeInfo: [AttendeeInfo]) {
        self.logAttendee(attendeeInfo: attendeeInfo, action: "Left")
        self.removeAttendeesAndReload(attendeeInfo: attendeeInfo)
        
    }
    
    func attendeesDidDrop(attendeeInfo: [AttendeeInfo]) {
        for attendee in attendeeInfo {
            self.notify(msg: "\(attendee.externalUserId) dropped")
        }
        
        self.removeAttendeesAndReload(attendeeInfo: attendeeInfo)
    }
    
    func attendeesDidMute(attendeeInfo: [AttendeeInfo]) {
        self.logAttendee(attendeeInfo: attendeeInfo, action: "Muted")
    }
    
    func attendeesDidUnmute(attendeeInfo: [AttendeeInfo]) {
        self.logAttendee(attendeeInfo: attendeeInfo, action: "Unmuted")
    }
}

extension StreamingManager:MetricsObserver{
    func metricsDidReceive(metrics: [AnyHashable : Any]) {
        guard let observableMetrics = metrics as? [ObservableMetric: Any] else {
            self.logger.error(msg: "The received metrics \(metrics) is not of type [ObservableMetric: Any].")
            return
        }
        self.logger.info(msg: "Media metrics have been received: \(observableMetrics)")
    }
    
    
}

extension StreamingManager:DeviceChangeObserver,ActiveSpeakerObserver{
    var observerId: String {
        
        return self.uuid
    }
    
    func activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo]) {
        self.activeSpeakerIds = attendeeInfo.map { $0.attendeeId }
    }
    
    func audioDeviceDidChange(freshAudioDeviceList: [MediaDevice]) {
        let deviceLabels: [String] = freshAudioDeviceList.map { device in "* \(device.label)" }
        managedView.makeToast("Device availability changed:\nAvailable Devices:\n\(deviceLabels.joined(separator: "\n"))")
    }
    
    
}
