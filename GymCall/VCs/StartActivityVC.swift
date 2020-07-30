//
//  StartActivityVC.swift
//  GymCall
//
//  Created by FreeBird on 5/16/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import UIKit
import Stevia
import LBTATools
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Toast_Swift
import PopupDialog

import AmazonChimeSDK
import AVFoundation
import AVKit
//import Toast
enum PageType:String{
    case createActivity
    case inviteActivity
}


enum RealTimeListeners:String{
    case inviteListener
    case videoPlayerListener
    case readyAsClientListener
}
struct MainStatus{
    var pageType:PageType = .createActivity
    var invitedId:String?
    var myRoomId:String?
}

class StartActivityVC: UIViewController{
        
    var streamingViewWrapper:[StreamingView] = []{
        didSet{
            renderViews = streamingViewWrapper.map({$0.renderView})
            StreamingManager.shared.videoTiles = renderViews
        }
    }

    var renderViews:[DefaultVideoRenderView] = []
    var vcStatus = MainStatus(pageType: .createActivity, invitedId: nil, myRoomId: nil)
    
    func finishInvite() {
        let vc = ActivitySelectorVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var activityType:ActivityType = ActivityType.Bump
    var imageLink:String = ""

    
    func sendInvite() {
        
        let vc = AlertService.shared.alertIndicator()
        vc.currentStep = 5
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    var maxWaitingTime:Int = 30
    var isLastStep:Bool = false
    var endTimerFlag:Bool = false
    let superView:UIView = {
        let v = UIView(psEnabled: false)
        return v
    }()
    
    let startBtn : UIButton = {
        
        let b = UIButton(psEnabled: false)
        b.backgroundColor = UIColor(hexString: "#FD7028")
        b.setTitle("Start", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont(name: FontNames.OpenSansBold, size: 21)
        return b
        
    }()
    
    let inviteBtn : UIButton = {
        
        let b = UIButton(psEnabled: false)
        b.backgroundColor = UIColor(hexString: "#FD7028")
        b.setTitle("Invite", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont(name: FontNames.OpenSansBold, size: 21)
        return b
        
    }()
    
    let endBtn : UIButton = {
        
        let b = UIButton(psEnabled: false)
        b.backgroundColor = UIColor(hexString: "#FD7028")
        b.layer.cornerRadius = 12
        b.setTitle("End", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont(name: FontNames.OpenSansBold, size: 15)
        
        return b
        
    }()
    
    
    let ltContainer:StreamingView = {
        let v = StreamingView(psEnabled: false)
        v.placeholer = "Random"
        v.layer.cornerRadius = 40
        v.layer.borderWidth = 4
        v.layer.borderColor = UIColor(hexString: "#80BEF0").cgColor
        v.backgroundColor = UIColor(hexString: "#D4E5F3")
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    
    let rtContainer:StreamingView = {
        
        let v = StreamingView(psEnabled: false)
        v.placeholer = "Random"
        v.layer.cornerRadius = 40
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        v.layer.borderColor = UIColor(hexString: "#ACA4F8").cgColor
        v.backgroundColor = UIColor(hexString: "#E0DEF5")
        return v
    }()
    
    let lbContainer:StreamingView = {
        
        let v = StreamingView(psEnabled: false)
        v.placeholer = "Random"
        v.layer.cornerRadius = 40
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        v.layer.borderColor = UIColor(hexString: "#80BEF0").cgColor
        v.backgroundColor = UIColor(hexString: "#D4E5F3")
        v.contentMode = .scaleAspectFill
        return v
        
    }()
    
    
    let rbContainer:StreamingView = {
        
        let v = StreamingView(psEnabled: false)
        v.placeholer = "Random"
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
    
    let videoPlayer = VideoPlayer()
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
    
    let optionPan:UIView = {
        let b = UIButton(psEnabled: false)
        return b
    }()
    
    let logger = ConsoleLogger(name: "StartActivityVC")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAction()
        streamingViewWrapper = [rtContainer,ltContainer,lbContainer,rbContainer]
        
        myStatus.currentStatus = .createActivity
        let alert = AlertService.shared.alertSelection()
        alert.delegate = self
        alert.modalPresentationStyle = .overCurrentContext
        self.present(alert, animated: false, completion: nil)
    }
    
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return.portrait
    }

    func playVideo(){
        
        let vc = StartLandscapeVC()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
    }
    func setupAction(){
        endBtn.addTarget(self, action: #selector(finishActivity), for: .touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if StreamingManager.shared.isStartMeeting {
            StreamingManager.shared.isMuted = false
        }
    }
    
    @objc func finishActivity(){
        
        StreamingManager.shared.leaveMeeting()
        registerStep(with: ActivityProgress.playEnd)
        guard let id = myStatus.meettingId else{
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        NetWorkManager.shared.deleteRoom(with: id) { (result) in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let err):
                let msg = Utils.FirebaseErrAnalysis(err: err)
                self.view.makeToast(msg)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        NetWorkManager.shared.registerJoinedFlag(with: false) { (result) in
            switch result{
            case .success(_):
                print("okay")
            case .failure(let err):
                print("failed")
                print(err.localizedDescription)
            }
        }
        
    }
    
    
    let leftStreamingView:UIView = {
        
        let v = UIView(psEnabled: false)
        v.backgroundColor = .systemBackground
        return v
    }()
    
    func setupView(){
        
        view.backgroundColor = .systemBackground
        view.addSubview(superView)
        superView.fillSuperviewSafeAreaLayoutGuide()
        //   superView.backgroundColor = .red
        superView.addSubview(ltContainer)
        superView.addSubview(lbContainer)
        superView.addSubview(rbContainer)
        superView.addSubview(rtContainer)
        superView.addSubview(endBtn)
        
        ltContainer.width(50%)
        lbContainer.width(50%)
        rbContainer.width(50%)
        rtContainer.width(50%)
        
        NSLayoutConstraint.activate([
            
            lbContainer.heightAnchor.constraint(equalTo: lbContainer.widthAnchor, multiplier: 0.67),
            
            lbContainer.heightAnchor.constraint(equalTo: ltContainer.widthAnchor, multiplier: 0.67),
            ltContainer.heightAnchor.constraint(equalTo: ltContainer.widthAnchor, multiplier: 0.67),
            rbContainer.heightAnchor.constraint(equalTo: rbContainer.widthAnchor, multiplier: 0.67),
            rtContainer.heightAnchor.constraint(equalTo: rtContainer.widthAnchor, multiplier: 0.67),
        ])
        
        lbContainer.left(0)
        rtContainer.right(0)
        lbContainer.bottom(0)
        rbContainer.bottom(0)
        rbContainer.right(0)
        
        
        endBtn.isHidden = true
        endBtn.width(54)
        endBtn.height(25)
        
        superView.layout(
            
            endBtn,
            20,
            rbContainer
            
        )
        
        endBtn.right(10)
        
        superView.addSubview(myStreamingView)
        myStreamingView.isHidden = true
        myStreamingView.centerInContainer()
        myStreamingView.fillHorizontally()
        
        myStreamingView.addSubview(optionPan)
        optionPan.addSubview(meterView)
        optionPan.addSubview(instaBtn)
        optionPan.addSubview(youtubBtn)
        instaBtn.width(35).height(35)
        youtubBtn.width(35).height(35)
        
        optionPan.layout(
            meterView,
            5,
            instaBtn,
            5,
            youtubBtn
        )
        
        meterView.centerHorizontally()
        instaBtn.centerHorizontally()
        youtubBtn.centerHorizontally()
        

        optionPan.right(30)
        optionPan.top(15)
        
        myStreamingView.addSubview(optionPan)
        meterView.width(64)
        meterView.height(64)
        meterView.addSubview(progressTimeLbl)
        meterView.addSubview(unitText1)
        progressTimeLbl.centerVertically(-5)
        unitText1.centerVertically(10)
        
        progressTimeLbl.centerHorizontally()
        unitText1.centerHorizontally()
        
        myStreamingView.anchor(top: rtContainer.bottomAnchor, leading: superView.leadingAnchor, bottom: rbContainer.topAnchor, trailing: superView.trailingAnchor)
        
    }
    
    
    func showNetworkingTime(){
        
        let vc = AlertService.shared.alertIndicator()
        vc.currentStep = 3
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
}

extension StartActivityVC:IndicatorViewDelegate{
    
    
    func startMainActivity() {
      //  playVideo()
    }
    func exitJoin() {
        finishActivity()
    }


    func endActivityFromIndicatorView() {
        finishActivity()
    }

    func endStep(step: Int) {
        var value:ActivityProgress = .waiting
        switch step {
        case 0:
            value = ActivityProgress.start
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                  if response {
                      //access granted
                  } else {

                  }
            }
        case 1:
            value = ActivityProgress.ready
            getVideoLink()
        case 2:
            StreamingManager.shared.isMuted = false
            playVideo()
            value = ActivityProgress.inProgress
        case 3:
            StreamingManager.shared.isMuted = true
            value = ActivityProgress.playEnd
        default:
            value = ActivityProgress.waiting
        }
        registerStep(with: value)
    }
    
    func registerStep(with value:ActivityProgress){
        guard let id = myStatus.meettingId else{
            return
        }
        print(id)
        NetWorkManager.shared.registerActivityProgress(with: id, activityProgress: value) { (result) in
            switch result{
            case.success(_):
                print("okay")
            case.failure(_):
                self.view.makeToast("Service has some problems. you will lost some users")
            }
        }
    }
    
    func getVideoLink(){
        NetWorkManager.shared.getVideoLink(with: myRoomId) { (result) in
            switch result{
            case.success(let link):
                myStatus.youtubLink = link
            case.failure(let err):
                print(err.localizedDescription)
                self.view.makeToast("Something went wrong ...")
            }
        }
    }
    
    func failedJoin(step: Int) {
        print("not needed")
    }
    
    func joinSuccess() {
       //playVideo()
        print("not needed")
    }
}


extension StartActivityVC:StartAlertVCDelegate{
    
    
    func cancelActivity() {
        self.finishActivity()
    }
    func startPlease() {
        
        StreamingManager.shared.createMyRoom(with: nil)
        let alert = AlertService.shared.alertIndicator()
        alert.modalPresentationStyle = .overCurrentContext
        alert.delegate = self
        present(alert, animated: true, completion: nil)
    
    }
    
    //call invite alert
    
    func inviteFriends() {
        let alert = AlertService.shared.inviteFriend()
        alert.modalPresentationStyle = .overCurrentContext
        alert.delegate = self
        present(alert, animated: true, completion: nil)
    }
    
}

extension StartActivityVC:InviteVCDelegate{
    
    func startedAsInvite() {
        
        guard let id = myStatus.meettingId else{
            self.view.makeToast("Service has some problems, We will get back you soon!.")
            return
        }
        
        StreamingManager.shared.createMeeting(with: id)
        let alert = AlertService.shared.alertIndicator()
        alert.currentStep = 5
        alert.modalPresentationStyle = .overCurrentContext
        alert.delegate = self
        present(alert, animated: true, completion: nil)
        
    }
}

extension StartActivityVC:VideoPlayerDelegate{
    
    func finishedPlay() {
        self.showNetworkingTime()
    }
    
}


extension StartActivityVC:StartLandscapeVCDelegate{
    
    func endPlay(){
   
        self.showNetworkingTime()
        StreamingManager.shared.isMuted = false
        StreamingManager.shared.videoTiles = []
        StreamingManager.shared.videoTiles = renderViews
        
    }
    func endActivity() {
        StreamingManager.shared.isMuted = false
        self.finishActivity()
    }
}





#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct StartActivityVCViewRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> StartActivityVC {
        return StartActivityVC()
    }
    
    func updateUIViewController(_ uiViewController: StartActivityVC, context: Context) {
    }
}

@available(iOS 13.0, *)
struct StartActivityVC_Preview: PreviewProvider {
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
