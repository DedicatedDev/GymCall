//
//  JoinIndicatorAlert.swift
//  GymCall
//
//  Created by FreeBird on 6/19/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import UIKit
import Stevia

protocol JoinIndicatorViewDelegate {
    func failedJoin(step:Int)
    func successJoin()
    func exitJoin()
}



class JoinIndicatorViewController: UIViewController {
    
    var delegate:JoinIndicatorViewDelegate?
    let searchIndicator:GradientView = {
        
        let v = GradientView(gradientStartColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), gradientEndColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) )
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.borderColor = UIColor(hexString: "#707070").cgColor
        v.layer.cornerRadius = 108
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        return v
        
    }()
    
    let gradientView: GradientView = {
        let v = GradientView(gradientStartColor: #colorLiteral(red: 0.96156317, green: 0.6877018213, blue: 0.1000254229, alpha: 1), gradientEndColor:#colorLiteral(red: 0.8378217816, green: 0.501537323, blue: 0.001147449133, alpha: 1) )
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let searchText:UILabel = {
        
        let l = UILabel(psEnabled: false)
        l.text = "Connecting"
        l.font = UIFont(name: FontNames.OpenSansBold, size: 31)
        l.textColor = .gray
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    let timeText:UILabel = {
        
        let l = UILabel(psEnabled: false)
       l.text = "0"
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
    
    let endBtn : UIButton = {
        
        let b = UIButton(psEnabled: false)
        b.backgroundColor = UIColor(hexString: "#FD7028")
        b.layer.cornerRadius = 12
        b.setTitle("End", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont(name: FontNames.OpenSansBold, size: 15)
        return b
        
    }()

    var endStepFlags:[Bool] = [false,false,false,false,false]
    var activityEndFlag:Bool = false
    var currenStep:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupView()
        setupTheme(with: currenStep)
        addListener()
    }
    
    func addListener(){
        
        guard let id = myStatus.meettingId else{
            return
        }
        NetWorkManager.shared.startListener(id:RealTimeListeners.inviteListener.rawValue, myRoomId: id) { (result) in
            switch result{
            case.success(let state):
                switch state {
                case ActivityProgress.waiting.rawValue:
                    print("start")
                case ActivityProgress.start.rawValue:
                    self.endStepFlags[0] = true
                case ActivityProgress.ready.rawValue:
                    self.endStepFlags[1] = true
                case ActivityProgress.inProgress.rawValue:
                    self.endStepFlags[2] = true
                    StreamingManager.shared.isMuted = true
                case ActivityProgress.playEnd.rawValue:
                    StreamingManager.shared.isMuted = false
                    self.endStepFlags[3] = true
                    
                default:
                    self.view.makeToast("Something went wrong ...")
                }
            case.failure(let err):
                print(Utils.FirebaseErrAnalysis(err: err))
            }
        }
        
    }

    
    func setupView(){
        
        view.addSubview(searchIndicator)
        searchIndicator.width(216)
        searchIndicator.height(216)
        searchIndicator.centerInContainer()
        
        searchIndicator.width(216)
        searchIndicator.height(216)
        searchIndicator.centerInContainer()
        searchIndicator.addSubview(searchText)
        searchIndicator.addSubview(timeText)
        searchIndicator.addSubview(unitText)
            
        searchIndicator.stack(UIView(),searchIndicator.stack(searchText,timeText,unitText),UIView(),distribution:.equalCentering).padTop(10).padBottom(10)
        searchText.centerHorizontally()
        timeText.centerHorizontally()
        unitText.centerHorizontally()
        
        view.addSubview(endBtn)
        endBtn.width(54)
        endBtn.height(25)
        endBtn.top(75.6%)
        
        NSLayoutConstraint.activate([
            endBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    
        endBtn.addTarget(self, action: #selector(endTimer), for: .touchDown)
    
    }
    
    func setupTheme(with step:Int){
        
        switch step {
        case 1:
            changeStyleToHi()
        case 2:
            changeStyleToReady()
        case 3:
            changeStyleToNetworkingTime()
        case 5:
            sendingInviteTheme()
        default:
            setupDefaultTheme()
        }

    }
    
    func setupDefaultTheme(){
        
        searchIndicator.setColor(gradientStartColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), gradientEndColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        searchText.text = "Searching"
        timeText.text = "\(StepTime.search.rawValue)"
        unitText.text = "sec"
        
        startCountInInviteAction(maxTime: StepTime.search.rawValue, again: false, step: 0)
    }
    
    @objc func endTimer(){
        
        self.activityEndFlag = true
        if currenStep == 3{
            dismiss(animated: true, completion: {
                self.delegate?.exitJoin()
            })
        }
    }
    
    
    func startCountInInviteAction(maxTime:Int,again:Bool,step:Int){
        
        var waitTime = maxTime
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            self.timeText.text = "\(waitTime)"
            if self.activityEndFlag{
                self.delegate?.failedJoin(step: step)
                self.dismiss(animated: true)
                timer.invalidate()
            }

            if self.endStepFlags[step]{
                let nextStep = step + 1
                if nextStep == 3{
                   NetWorkManager.shared.removeListener(with: RealTimeListeners.inviteListener.rawValue)
                    self.dismiss(animated: true) {
                        self.delegate?.successJoin()
                    }
                     timer.invalidate()
                    
                }else{
                    self.setupTheme(with: step + 1)
                    timer.invalidate()
                }
            }
            
            
            if waitTime == -10 {
                self.delegate?.exitJoin()
                timer.invalidate()
            }
            
            waitTime -= 1
        }
    }
    

    func changeStyleToHi(){
        
        searchIndicator.backgroundColor = UIColor(hexString: "#C86868")
        searchIndicator.layer.borderColor = UIColor.white.cgColor
        searchIndicator.setColor(gradientStartColor: UIColor(hexString: "#CB6969"), gradientEndColor: UIColor(hexString: "#FFBE95"))
        timeText.textColor = .white
        unitText.textColor = .white
        searchText.textColor = .white
        searchText.text = "Say Hi:)"
        timeText.text = "\(StepTime.hi.rawValue)"
        
        startCountInInviteAction(maxTime: StepTime.hi.rawValue, again: false, step: 1)
        
    }
    
    func changeStyleToReady(){
        
        self.searchText.text = "Ready?!"
        self.timeText.text = "\(StepTime.ready.rawValue)"
        
        startCountInInviteAction(maxTime: StepTime.ready.rawValue, again: false, step: 2)
    
    }
    
    func changeStyleToNetworkingTime(){
     
        searchIndicator.backgroundColor = UIColor(hexString: "#C86868")
        searchIndicator.layer.borderColor = UIColor.white.cgColor
        searchIndicator.setColor(gradientStartColor: UIColor(hexString: "#CB6969"), gradientEndColor: UIColor(hexString: "#FFBE95"))
        timeText.textColor = .white
        unitText.textColor = .white
        searchText.textColor = .white
        self.searchText.text = "Networking\n Time"
        self.timeText.text = ""
        self.unitText.text = ""
    }
    
    func sendingInviteTheme(){
        
      searchIndicator.setColor(gradientStartColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), gradientEndColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
      searchText.text = "Sending\nInvite"
      timeText.text = "30"
      unitText.text = "sec"
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct JoinIndicatorViewControllerViewRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> IndicatorViewController {
        return IndicatorViewController()
    }

    func updateUIViewController(_ uiViewController: IndicatorViewController, context: Context) {
    }
}

@available(iOS 13.0, *)
struct JoinIndicatorViewController_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            IndicatorViewControllerViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
            .edgesIgnoringSafeArea(.all)
            IndicatorViewControllerViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
            .edgesIgnoringSafeArea(.all)
            IndicatorViewControllerViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
            .edgesIgnoringSafeArea(.all)
        }

    }
}
#endif
