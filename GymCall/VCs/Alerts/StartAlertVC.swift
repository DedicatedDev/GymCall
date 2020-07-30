//
//  AlertViewController.swift
//  GymCall
//
//  Created by FreeBird on 5/18/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import UIKit
import Stevia


protocol  StartAlertVCDelegate {
    
    func startPlease()
    func inviteFriends()
    func cancelActivity()
    
}
class StartAlertVC: UIViewController {
    
    var delegate:StartAlertVCDelegate?
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
    
    var endTimerFlag:Bool = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupView()
        setupAction()
    }
    
    func setupView(){
        
        view.addSubview(searchIndicator)
       
      
        startBtn.width(149)
        startBtn.height(59)
        startBtn.dropShadow()
        startBtn.layer.cornerRadius = 25
        
        inviteBtn.height(59)
        inviteBtn.width(207)
        inviteBtn.dropShadow()
        inviteBtn.layer.cornerRadius = 25
        
        view.addSubview(startBtn)
        view.addSubview(inviteBtn)
        view.addSubview(endBtn)
        
        view.layout(
        
            |-startBtn-| ~ 80,
            10,
            |-inviteBtn|
        
        )
        
        endBtn.width(54)
        endBtn.height(25)
        endBtn.right(10)
        endBtn.top(70%)
        startBtn.centerHorizontally()
        inviteBtn.centerHorizontally()
        startBtn.centerVertically(-30)
        
    
    }
    
    func setupAction(){
        
        startBtn.addTarget(self, action: #selector(startActivity), for: .touchDown)
        inviteBtn.addTarget(self, action: #selector(inviteFriends), for: .touchDown)
        
        endBtn.addTarget(self, action: #selector(finishActivity), for: .touchDown)
    }
    
    @objc func finishActivity(){
        
        dismiss(animated: true) {
        self.delegate?.cancelActivity()
        }
    }

    @objc func startActivity(){
    
        dismiss(animated: true) {
            self.delegate?.startPlease()
        }

    }
    
    @objc func inviteFriends(){
       
        dismiss(animated: true) {
            self.delegate?.inviteFriends()
        }
    }
    
}




#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct StartAlertVCViewRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> StartAlertVC {
        return StartAlertVC()
    }

    func updateUIViewController(_ uiViewController: StartAlertVC, context: Context) {
    }
}

@available(iOS 13.0, *)
struct StartAlertVC_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            StartAlertVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
            .edgesIgnoringSafeArea(.all)
            StartAlertVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
            .edgesIgnoringSafeArea(.all)
            StartAlertVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
            .edgesIgnoringSafeArea(.all)
        }

    }
}
#endif
