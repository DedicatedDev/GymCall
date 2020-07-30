//
//  AlertViewController.swift
//  GymCall
//
//  Created by FreeBird on 5/18/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import UIKit
import Stevia


enum  IndicatorActionStyle {
    case inviteAction
    case createAction
}
protocol IndicatorViewDelegate {
    func endStep(step:Int)
    func failedJoin(step:Int)
    func exitJoin()
    func startMainActivity()
}

class IndicatorViewController: UIViewController {
    
    var endTimerFlag:Bool = false
    var indicatorType:IndicatorActionStyle = .createAction
    
    
    var currentStep:Int = 0
    var delegate:IndicatorViewDelegate?
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
        l.text = "Searching"
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupView()
        
        setupTheme(with: self.currentStep)
        
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
       
            endBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
            
        ])
        
        if UIDevice.current.orientation.isLandscape{
//            endBtn.right(20%)
        }else{
            endBtn.right(3%)
        }
        
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

    @objc func endTimer(){
           
        self.endTimerFlag = true
        if currentStep == 3{
            delegate?.exitJoin()
            dismiss(animated: true, completion: nil)
        }
    
    }
    
    
    func startCount(maxTime:Int,again:Bool,step:Int){
           
        var waitTime = maxTime
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
        { timer in
            
            self.timeText.text = "\(waitTime)"
            if self.endTimerFlag{
                self.delegate?.exitJoin()
                self.dismiss(animated: true, completion: nil)
                timer.invalidate()
            }

            if waitTime == 0{

                if step == 2 {
                    self.delegate?.startMainActivity()
                    self.dismiss(animated: true, completion: {timer.invalidate()})
                }

                self.setupTheme(with: step + 1)
                self.delegate?.endStep(step: step)
                timer.invalidate()
            }
            waitTime -= 1

        }
    }
    
    func setupDefaultTheme(){
        
        searchIndicator.setColor(gradientStartColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), gradientEndColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        searchText.text = "Searching"
        timeText.text = "13"
        unitText.text = "sec"
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.startCount(maxTime: StepTime.search.rawValue, again: true, step: self.currentStep)
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
        
        self.startCount(maxTime: StepTime.hi.rawValue, again: false, step: 1)
        
    }
    
    func changeStyleToReady(){
        
        self.searchText.text = "Ready?!"
        self.timeText.text = "\(StepTime.ready.rawValue)"
        self.startCount(maxTime: StepTime.ready.rawValue, again: false, step: 2)
       
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
      self.currentStep = 0
      startCount(maxTime: 13, again: false, step: 0)
        
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct IndicatorViewControllerViewRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> IndicatorViewController {
        return IndicatorViewController()
    }

    func updateUIViewController(_ uiViewController: IndicatorViewController, context: Context) {
    }
}

@available(iOS 13.0, *)
struct IndicatorViewController_Preview: PreviewProvider {
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
