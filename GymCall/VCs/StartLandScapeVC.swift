//
//  StartLandScapeVC.swift
//  GymCall
//
//  Created by FreeBird on 6/16/20.
//  Copyright © 2020 GymCall. All rights reserved.
//


import UIKit
import Stevia
import LBTATools
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Toast_Swift
import SwiftWebVC

import AmazonChimeSDK
import AVFoundation
import AVKit

protocol StartLandscapeVCDelegate {
    func endPlay()
    func endActivity()
}

enum ExitType {
    case exitActivity
    case finishedPlay
    case joinOut
}

class StartLandscapeVC: UIViewController {
    
    var delegate:StartLandscapeVCDelegate?
    var streamingViewWrapper:[StreamingView] = []{
        didSet{
            renderViews = streamingViewWrapper.map({$0.renderView})
            StreamingManager.shared.videoTiles = renderViews
               
        }
    }
    
    var renderViews:[DefaultVideoRenderView] = []

    let superView:UIView = {
        let v = UIView(psEnabled: false)
        return v
    }()
    
    var isShowing:Bool = false
    let endBtn : UIButton = {
        
        let b = UIButton(psEnabled: false)
        b.backgroundColor = UIColor(hexString: "#FD7028")
        b.layer.cornerRadius = 12
        b.setTitle("End", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont(name: FontNames.OpenSansBold, size: 15)
        
        return b
        
    }()
    
    
    let user1CameraView:StreamingView = {
        let v = StreamingView(psEnabled: false)
        v.layer.cornerRadius = 40
        v.layer.borderWidth = 4
        v.layer.borderColor = UIColor(hexString: "#80BEF0").cgColor
        v.backgroundColor = UIColor(hexString: "#D4E5F3")
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    
    let user0CameraView:StreamingView = {
        
        let v = StreamingView(psEnabled: false)
        v.layer.cornerRadius = 40
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        v.layer.borderColor = UIColor(hexString: "#ACA4F8").cgColor
        v.backgroundColor = UIColor(hexString: "#E0DEF5")
        return v
    }()
    
    let user3CameraView:StreamingView = {
        
        let v = StreamingView(psEnabled: false)
        v.layer.cornerRadius = 40
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        v.layer.borderColor = UIColor(hexString: "#80BEF0").cgColor
        v.backgroundColor = UIColor(hexString: "#D4E5F3")
        v.contentMode = .scaleAspectFill
        return v
        
    }()
    
    
    let user2CameraView:StreamingView = {
        
        let v = StreamingView(psEnabled: false)
        v.layer.cornerRadius = 40
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        v.layer.borderColor = UIColor(hexString: "#ACA4F8").cgColor
        v.backgroundColor = UIColor(hexString: "#E0DEF5")
        v.contentMode = .scaleAspectFill
        return v
        
    }()
    
        
    let searchIndicator:GradientView = {
        
        let v = GradientView(gradientStartColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), gradientEndColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) )
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.borderColor = UIColor(hexString: "#707070").cgColor
        v.layer.cornerRadius = 108
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        v.backgroundColor = .systemBackground
        return v
        
    }()
    
    let gradientView: GradientView = {
        let v = GradientView(gradientStartColor: #colorLiteral(red: 0.96156317, green: 0.6877018213, blue: 0.1000254229, alpha: 1), gradientEndColor:#colorLiteral(red: 0.8378217816, green: 0.501537323, blue: 0.001147449133, alpha: 1) )
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    
    let searchText:UILabel = {
        
        let l = UILabel(psEnabled: false)
        l.text = "Searching"
        l.font = UIFont(name: FontNames.OpenSansBold, size: 31)
        l.textColor = .gray
        l.textAlignment = .center
        return l
    }()
    
    let timeText:UILabel = {
        
        let l = UILabel(psEnabled: false)
        l.text = ""
        l.font = UIFont(name: FontNames.OpenSansBold, size: 25)
        l.textColor = .gray
        l.textAlignment = .center
        return l
    }()
    
    let unitText:UILabel = {
        
        let l = UILabel(psEnabled: false)
        l.text = "sec"
        l.font = UIFont(name: FontNames.OpenSansBold, size: 17)
        l.textColor = .gray
        l.textAlignment = .center
        return l
        
    }()
    
    let myStreamingView : UIView = {
        
        let v = UIView(psEnabled: false)
        v.backgroundColor = .white
        v.layer.cornerRadius = 40
        v.clipsToBounds = true
        
        return v
    }()
    
   // let videoPlayer = VideoPlayer()
    let meterView:UIView={
        
        let v = UIView (psEnabled: false)
        v.layer.cornerRadius = 32
        v.layer.borderColor = UIColor(hexString: "#707070").cgColor
        v.backgroundColor = UIColor(hexString: "#F3F3F3")
        v.layer.borderWidth = 1
        
        return v
    }()
    
    let progressTimeLbl:UILabel = {
        
        let l = UILabel(psEnabled: false)
        l.text = "30"
        l.font = UIFont(name: FontNames.OpenSansBold, size: 25)
        l.textColor = .gray
        l.textAlignment = .center
        
        return l
    }()
    
    let unitText1:UILabel = {
        
        let l = UILabel(psEnabled: false)
        l.text = "sec"
        l.font = UIFont(name: FontNames.OpenSansBold, size: 17)
        l.textColor = .gray
        l.textAlignment = .center
        return l
        
    }()
    
    let instaBtn:UIButton = {
        
        let b = UIButton(psEnabled: false)
        b.setBackgroundImage(#imageLiteral(resourceName: "Ellipse 14"), for: .normal)
        return b
        
    }()
    
    let youtubBtn:UIButton = {
        let b = UIButton(psEnabled: false)
        b.setBackgroundImage(#imageLiteral(resourceName: "youtub"), for: .normal)
        return b
    }()
    
    let optionPan:UIStackView = {
        let b = UIStackView(psEnabled: false)
        return b
    }()
    
    let logger = ConsoleLogger(name: "StartActivityVC")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isShowing = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fileComplete),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil)
        
        StreamingManager.shared.isMuted = true
        setupLandScapeView()
        streamingViewWrapper = [user0CameraView,user1CameraView,user2CameraView,user3CameraView]
       
        
        if myStatus.currentStatus == PageType.inviteActivity{
            addListener()
        }else{
            showStreamingView()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetWorkManager.shared.removeListener(with: RealTimeListeners.videoPlayerListener.rawValue)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }
    
    func setupLandScapeView(){
        
        view.backgroundColor = .systemBackground
        view.addSubview(superView)
        superView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
//       superView.fillSuperview()
        //   superView.backgroundColor = .red
        
        superView.addSubview(myStreamingView)
        superView.addSubview(user1CameraView)
        superView.addSubview(user3CameraView)
        superView.addSubview(user2CameraView)
        superView.addSubview(user0CameraView)
        
        let height:CGFloat = (view.frame.width - 40)/3
        user1CameraView.height(height).width(106)
        user3CameraView.height(height).width(106)
        user2CameraView.height(height).width(106)
        user0CameraView.height(height).width(106)
        
        user3CameraView.right(0)
        user1CameraView.right(0)
        user1CameraView.top(0)
        user0CameraView.left(0)
        user0CameraView.top(0)
        user2CameraView.right(0)
        user2CameraView.topAnchor.constraint(equalTo: user1CameraView.bottomAnchor).isActive = true
        user3CameraView.topAnchor.constraint(equalTo: user2CameraView.bottomAnchor).isActive = true

        
//        user0CameraView.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
//        user0CameraView.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
//
//        user1CameraView.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
//        user1CameraView.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
//
//        user2CameraView.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
//        user2CameraView.topAnchor.constraint(equalTo: user1CameraView.bottomAnchor).isActive = true
//
//        user3CameraView.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
//         user3CameraView.topAnchor.constraint(equalTo: user2CameraView.bottomAnchor).isActive = true
        
        
        
        endBtn.isHidden = false
        endBtn.width(54)
        endBtn.height(25)
        
        endBtn.right(10)
        endBtn.bringSubviewToFront(superView)
        
        myStreamingView.isHidden = true
        myStreamingView.centerInContainer()
        myStreamingView.fillHorizontally()
        
        optionPan.addSubview(meterView)
        optionPan.addSubview(instaBtn)
        optionPan.addSubview(youtubBtn)
        
        instaBtn.width(35).height(35)
        youtubBtn.width(35).height(35)
        
        optionPan.addArrangedSubview(meterView)
        optionPan.addArrangedSubview(instaBtn)
        optionPan.addArrangedSubview(youtubBtn)
        optionPan.axis = .vertical
        optionPan.spacing = 5
        
        meterView.centerHorizontally()
        instaBtn.centerHorizontally()
        youtubBtn.centerHorizontally()
    
        meterView.width(64)
        meterView.height(64)
        meterView.addSubview(progressTimeLbl)
        meterView.addSubview(unitText1)
        progressTimeLbl.centerVertically(-5)
        unitText1.centerVertically(10)
        
        progressTimeLbl.centerHorizontally()
        unitText1.centerHorizontally()
        
        myStreamingView.fillSuperview()
        superView.addSubview(optionPan)
        superView.addSubview(endBtn)
        
        optionPan.right(110)
        optionPan.bottom(10)
        endBtn.right(30)
        endBtn.bottom(10)
        
        endBtn.addTarget(self, action: #selector(endBtnClick), for: .touchUpInside)
        youtubBtn.addTarget(self, action: #selector(openYoutube), for: .touchUpInside)
        instaBtn.addTarget(self, action: #selector(openInsta), for: .touchUpInside)
        setupFlow()
        
        
    }
    
    @objc func openInsta(){
        
         UIApplication.tryURL(urls: [
             "instagram://", // App
             "https://www.instagram.com/" // Website if app fails
        ])
     }
     
    
    @objc func openYoutube(){
        
        UIApplication.tryURL(urls: [
           "youtube://", // App
           "https://www.youtube.com/" // Website if app fails
        ])
    
    }
    
   
    
    func setupFlow(){
        
        user0CameraView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveCamera1)))
        
        user1CameraView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveCamera2)))
        user2CameraView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveCamera3)))
        user3CameraView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveCamera4)))
        
        
    }
    
    var pos1: (CGFloat, CGFloat) = (0, 0)
    var pos2: (CGFloat, CGFloat) = (0, 0)
    var pos3: (CGFloat, CGFloat) = (0, 0)
    var pos4: (CGFloat, CGFloat) = (0, 0)
    
    @objc func moveCamera1(guesture: UIPanGestureRecognizer){
        
        switch guesture.state  {
        case .began:
            print("okay")
        case .changed:
            let translation = guesture.translation(in: superView)
            user0CameraView.transform = CGAffineTransform(translationX: translation.x + pos1.0, y: translation.y + pos1.1)
        case .ended:
            print("ended")
            let translation = guesture.translation(in: superView)
            pos1.0 += translation.x
            pos1.1 += translation.y
        default:
            print("noaction")
        }
    }
    
    @objc func moveCamera2(guesture: UIPanGestureRecognizer){
           
           switch guesture.state  {
           case .began:
               print("okay")
           case .changed:
               let translation = guesture.translation(in: superView)
               user1CameraView.transform = CGAffineTransform(translationX: translation.x + pos2.0, y: translation.y + pos2.1)
           case .ended:
               print("ended")
               let translation = guesture.translation(in: superView)
               pos2.0 += translation.x
               pos2.1 += translation.y
           default:
               print("noaction")
           }
       }
    
    @objc func moveCamera3(guesture: UIPanGestureRecognizer){
           
           switch guesture.state  {
           case .began:
               print("okay")
           case .changed:
               let translation = guesture.translation(in: superView)
               user2CameraView.transform = CGAffineTransform(translationX: translation.x + pos3.0, y: translation.y + pos3.1)
           case .ended:
               let translation = guesture.translation(in: superView)
               pos3.0 += translation.x
               pos3.1 += translation.y
           default:
               print("noaction")
           }
       }
    
    @objc func moveCamera4(guesture: UIPanGestureRecognizer){
           
          switch guesture.state  {
           case .began:
               print("okay")
           case .changed:
               let translation = guesture.translation(in: superView)
               user3CameraView.transform = CGAffineTransform(translationX: translation.x + pos4.0, y: translation.y + pos4.1)
           case .ended:
               print("ended")
               let translation = guesture.translation(in: superView)
               pos4.0 += translation.x
               pos4.1 += translation.y
           default:
               print("noaction")
           }
       }
    
    @objc func endBtnClick(){
        if myStatus.currentStatus == .createActivity{
            finishActivity(with: ExitType.exitActivity)
        }else{
            finishActivity(with: ExitType.joinOut)
        }
    }
    
    @objc func fileComplete(){
        
        if myStatus.currentStatus == .createActivity{
            registerStep(with: ActivityProgress.playEnd)
        }
        dismiss(animated: true, completion: {
           self.delegate?.endPlay()
           NotificationCenter.default.removeObserver(self)
       })
    }
    
    func showStreamingView(){
        
        if isShowing {
            return
        }
        self.myStreamingView.isHidden = false
        self.meterView.isHidden = true
        self.myStreamingView.layer.borderWidth = 1
        self.myStreamingView.layer.borderColor = UIColor.green.cgColor
        self.myStreamingView.bringSubviewToFront(self.optionPan)
        
        if myStatus.youtubLink != nil {
            
            guard let videoId = getYoutubeId(youtubeUrl: myStatus.youtubLink!) else{
                self.view.makeToast("Loading failed. This chanel has some problems...")
                return
            }
            
            getParseURL(id: videoId) { (result) in
                switch result{
                case .success(let url):
                     self.configPlayer(with: url)
                case .failure(let err):
                    self.view.makeToast("Loading failed..")
                    print(err.localizedDescription)
                }
            }
    
        }else{
            self.view.makeToast("Something went wrong ...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.delegate?.endPlay()
                self.dismiss(animated: true, completion: nil)
            }
        }
        isShowing = true
    }

    func configPlayer(with url:URL){
        
        let audioSession = AVAudioSession.sharedInstance()
        do{
             try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .defaultToSpeaker])

        }catch{
            print("erro")
        }
        
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        myStreamingView.backgroundColor = .black
        myStreamingView.layer.addSublayer(playerLayer)
        playerLayer.frame = myStreamingView.bounds
        player.play()
        player.volume = 0.5
    }
        
    @objc func exitActivity(){
        
        guard let roomId = myStatus.meettingId else{
                return
            }
        
            StreamingManager.shared.leaveMeeting()
            print(myStatus)
            if myStatus.currentStatus == .createActivity{
                Spinner.start()
                NetWorkManager.shared.registerActivityProgress(with: roomId, activityProgress: ActivityProgress.exitActivity){ (result) in
                    Spinner.stop()
                    switch result{
                    case .success(_):
                        UserDefaults.standard.set(nil, forKey: "previousMeetingId")
                    case .failure(_):
                        UserDefaults.standard.set(roomId, forKey: "previousMeetingId")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           self.dismiss(animated: true) {
                               self.delegate?.endActivity()
                           }
                       }
                    }
            }else{
                
                self.dismiss(animated: true) {
                    self.delegate?.endActivity()
                }
            }
        
    }

    func finishActivity(with endType:ExitType){
        
      
        StreamingManager.shared.leaveMeeting()
        
        switch endType {
        case .exitActivity:
            registerStep(with: ActivityProgress.exitActivity)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true) {
                    self.delegate?.endActivity()
                }
            }
        case .finishedPlay:
            if myStatus.currentStatus == .createActivity{
                registerStep(with: ActivityProgress.playEnd)
            }
            self.dismiss(animated: true) {
                self.delegate?.endPlay()
            }
            
        case .joinOut:
            self.dismiss(animated: true) {
                self.delegate?.endActivity()
            }
        }
       
    }
            
    func registerStep(with progress:ActivityProgress){
        
        guard let roomId = myStatus.meettingId else{
                  return
        }
        NetWorkManager.shared.registerActivityProgress(with: roomId, activityProgress: progress) { (result) in
            switch result{
            case .success(_):
                UserDefaults.standard.set(nil, forKey: "previousMeetingId")
            case .failure(_):
                UserDefaults.standard.set(roomId, forKey: "previousMeetingId")
            }
        }
    }
    
    
    func addListener(){
        
        guard let id = myStatus.meettingId else{
            return
        }
        Spinner.start()
        NetWorkManager.shared.startListener(id:RealTimeListeners.videoPlayerListener.rawValue, myRoomId: id) { (result) in
            Spinner.stop()
            switch result{
            case.success(let state):
                switch state {
                case ActivityProgress.waiting.rawValue:
                    self.finishActivity(with: ExitType.joinOut)
                case ActivityProgress.start.rawValue:
                    self.finishActivity(with: ExitType.joinOut)
                case ActivityProgress.ready.rawValue:
                    print("okay")
                case ActivityProgress.inProgress.rawValue:
                    self.showStreamingView()
                case ActivityProgress.playEnd.rawValue:
                    
                    self.dismiss(animated: true, completion: {
                        self.delegate?.endPlay()
                        NetWorkManager.shared.removeListener(with: RealTimeListeners.videoPlayerListener.rawValue)
                    })
                    
                case ActivityProgress.exitActivity.rawValue:
                    NetWorkManager.shared.removeListener(with: RealTimeListeners.videoPlayerListener.rawValue)
                    self.finishActivity(with: ExitType.exitActivity)
                    
                default:
                    self.view.makeToast("Meeting is finished or you lost network connection.")
                    self.finishedPlay()
                }
            case.failure(let err):
                print(Utils.FirebaseErrAnalysis(err: err))
            }
        }
        
    }
    
    func finishedPlay() {
        self.delegate?.endPlay()
        dismiss(animated: true, completion: nil)
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct StartLandscapeVCViewRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> StartActivityVC {
        return StartActivityVC()
    }
    
    func updateUIViewController(_ uiViewController: StartActivityVC, context: Context) {
    }
}

@available(iOS 13.0, *)
struct StartLandscapeVC_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            StartActivityVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
                .edgesIgnoringSafeArea(.all)
            StartActivityVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
                .edgesIgnoringSafeArea(.all)
            StartActivityVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
                .edgesIgnoringSafeArea(.all)
        }
        
    }
}
#endif
