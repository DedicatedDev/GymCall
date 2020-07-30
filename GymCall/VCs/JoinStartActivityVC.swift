//
//  JoinStartActivityVC.swift
//  GymCall
//
//  Created by FreeBird on 6/18/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

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


class JoinStartActivityVC: UIViewController{
    
    var streamingViewWrapper:[StreamingView] = []{
        didSet{
            renderViews = streamingViewWrapper.map({$0.renderView})
             StreamingManager.shared.videoTiles = renderViews
        }
    }
    
    var renderViews:[DefaultVideoRenderView] = []
    var invitedRoomId:String = ""
    
    
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
        v.layer.cornerRadius = 40
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        v.layer.borderColor = UIColor(hexString: "#ACA4F8").cgColor
        v.backgroundColor = UIColor(hexString: "#E0DEF5")
        v.contentMode = .scaleAspectFill
        return v
        
    }()
    
    
    let ltMsgLbl:UILabel = {
        let l = UILabel(psEnabled: false)
        l.text = "No Match"
        l.font = UIFont(name: FontNames.OpenSansBold, size: 17)
        l.textColor = UIColor(hexString: "#50514F")
        return l
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
        streamingViewWrapper = [lbContainer,rbContainer,ltContainer,rtContainer]
        
        let acceptVC = InvitationAcceptVC()
        acceptVC.setMsg(with: myStatus.invitationMsg ?? "")
        acceptVC.delegate = self
        let popup = PopupDialog(viewController: acceptVC, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 351.adjusted, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: true, completion: nil)
            acceptVC.popup = popup
            present(popup, animated: true, completion: nil)
        
        
        //StreamingManager.shared.videoTiles = renderViews
//        guard let myId = myStatus.meettingId else{
//            return
//        }
//        StreamingManager.shared.createMeeting(with: myId)
//        checkStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
            super.viewWillAppear(animated)
            if StreamingManager.shared.isStartMeeting {
                StreamingManager.shared.isMuted = false
            }
    
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
    
    func checkStatus(){
        
        guard let id = myStatus.meettingId else{
            self.view.makeToast("Unable to join to this activity! Already Started!")
            StreamingManager.shared.leaveMeeting()
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        NetWorkManager.shared.checkStauts(with: id) { (result) in
            switch result{
            case.success(let response):
                switch response {
                case ActivityProgress.waiting.rawValue:
                    let alert = AlertService.shared.alertJoinIndicator()
                    alert.delegate = self
                    alert.modalPresentationStyle = .overCurrentContext
                    self.present(alert, animated: false, completion: nil)
                    
                default:
                    self.view.makeToast("Unable to join to this activity! Already Started!")
                    StreamingManager.shared.leaveMeeting()
                    self.navigationController?.popViewController(animated: true)
                }
            case.failure(_):
                StreamingManager.shared.leaveMeeting()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func playVideo(){

        DispatchQueue.main.async {
             let vc = StartLandscapeVC()
             vc.delegate = self
             vc.modalPresentationStyle = .fullScreen
             vc.modalTransitionStyle = .crossDissolve
             self.present(vc, animated: true, completion: nil)
        }
      
    }
  
    
    let leftStreamingView:UIView = {
        
        let v = UIView(psEnabled: false)
        v.backgroundColor = .systemBackground
        return v
    }()
    
    let superView:UIView = {
        let v = UIView(psEnabled: false)
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
    }
    
    
    func showNetworkingTime(){
        
        let vc = AlertService.shared.alertJoinIndicator()
        vc.currenStep = 3
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
}

extension JoinStartActivityVC:JoinIndicatorViewDelegate{
    
    func exitJoin() {
        StreamingManager.shared.leaveMeeting()
        StreamingManager.shared.resetManager()
        navigationController?.popViewController(animated: true)
    }

    func failedJoin(step: Int) {
        StreamingManager.shared.leaveMeeting()
        navigationController?.popViewController(animated: true)
    }
    
    func successJoin() {
        playVideo()
    }
}

extension JoinStartActivityVC:StartLandscapeVCDelegate{
    
    func endPlay() {

        StreamingManager.shared.isMuted = false
        StreamingManager.shared.videoTiles = []
        StreamingManager.shared.videoTiles = renderViews
        self.showNetworkingTime()
        
    }
    
    func endActivity() {
        StreamingManager.shared.isMuted = false
        StreamingManager.shared.leaveMeeting()
        navigationController?.popViewController(animated: true)
    }
    
}

extension JoinStartActivityVC:InvitationAcceptVCDelegate{
    
    func agreeContent() {
        StreamingManager.shared.videoTiles = renderViews
        guard let myId = myStatus.meettingId else{
            return
        }
        StreamingManager.shared.createMeeting(with: myId)
        checkStatus()
    }
    
    func declineContent() {
        
        navigationController?.popViewController(animated: true)
    }
    
    
}




