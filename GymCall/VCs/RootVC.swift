//
//  RootVC.swift
//  GymCall
//
//  Created by FreeBird on 5/15/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import UIKit
import Stevia

class RootVC: UIViewController {

    
    let alerService = AlertService()
    let coloredLogo:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = MainColors.BtnColor
        l.text = "GymCall"
        l.font = .systemFont(ofSize: 50)
        return l
    }()
    
    let avatar1 = UIImageView(image: #imageLiteral(resourceName: "excercise"))
    let avatar2 = UIImageView(image: #imageLiteral(resourceName: "yogagirl"))
    let avatar3 = UIImageView(image: #imageLiteral(resourceName: "weight-loss"))
    
    let loginBtn:UIButton = {

        let b = UIButton(psEnabled: false)
        b.backgroundColor = MainColors.BtnColor
        b.setTitle("Login", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.width(205)
        b.height(55)
        b.layer.cornerRadius = 22.5
        
        return b
    }()
    
    let forgotPwdBtn : UIButton = {
        let b = UIButton(psEnabled: false)
        b.setTitle("Forgot Your Password", for: .normal)
        b.setTitleColor(MainColors.BtnColor, for:  .normal)
        return b
    }()
    
    let RegisterBtn: UIButton = {
        let b = UIButton(psEnabled: false)
        b.setTitleColor(MainColors.BtnColor, for: .normal)
        b.setTitle("Register", for: .normal)
        return b
    }()
    
    let avatarContainer = UIView()
    let container = UIView()
    let backImgContainer = UIView(psEnabled: false)
    
    let leftImgView:UIImageView = {
        let iv = UIImageView(psEnabled: false)
        iv.image = #imageLiteral(resourceName: "leftimg")
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let rightImgView:UIImageView = {
        let iv = UIImageView(psEnabled: false)
        iv.image = #imageLiteral(resourceName: "rightIimg")
        iv.contentMode = .scaleToFill
        return iv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        setupAction()
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
    

    func setupView(){
        
        self.TransparentNavVC()
        view.backgroundColor = .white
        view.addSubview(coloredLogo)
        view.addSubview(RegisterBtn)
        view.addSubview(loginBtn)
        view.addSubview(backImgContainer)
        view.addSubview(forgotPwdBtn)
    
        backImgContainer.addSubview(leftImgView)
        backImgContainer.addSubview(rightImgView)
        
        leftImgView.height(100%)
        rightImgView.height(100%)
        leftImgView.widthAnchor.constraint(equalTo: leftImgView.heightAnchor, multiplier: 0.44).isActive = true
        rightImgView.widthAnchor.constraint(equalTo: rightImgView.heightAnchor, multiplier: 0.44).isActive = true
        rightImgView.right(0)
        rightImgView.addSubview(avatar3)
        avatar3.centerHorizontally()
        avatar3.centerVertically()
        avatar3.translatesAutoresizingMaskIntoConstraints = false
        avatar1.translatesAutoresizingMaskIntoConstraints = false
        avatar2.translatesAutoresizingMaskIntoConstraints = false
        
        leftImgView.addSubview(avatar1)
        avatar1.centerVertically()
        avatar1.centerHorizontally()
        
        backImgContainer.addSubview(avatar2)
        avatar2.centerVertically()
        avatar2.centerHorizontally()
        

        backImgContainer.width(100%)
        backImgContainer.height(39%)
        backImgContainer.centerHorizontally()
        backImgContainer.topAnchor.constraint(equalTo: coloredLogo.bottomAnchor, constant: 0).isActive = true
       // backImgContainer.centerVertically(-100)
        
//        loginBtn.topAnchor.constraint(equalTo: backImgContainer.bottomAnchor, constant: 20).isActive = true
//
        loginBtn.top(65%)
        forgotPwdBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 15).isActive = true
        forgotPwdBtn.centerHorizontally()
    
        RegisterBtn.centerHorizontally()
        coloredLogo.centerHorizontally()
        coloredLogo.top(50)
        RegisterBtn.bottom(8%)

        loginBtn.centerHorizontally()

    
    }
    
    
    func setupAction(){
        
        loginBtn.addTarget(self, action: #selector(gotoLogin), for: .touchDown)
        forgotPwdBtn.addTarget(self, action: #selector(gotoFogotPwd), for: .touchDown)
        RegisterBtn.addTarget(self, action: #selector(gotoRegisterVC), for: .touchDown)
        
    }
    
    @objc func gotoLogin(){
        
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func gotoFogotPwd(){
        
        let vc = ForgetPwdVC()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func gotoRegisterVC(){
        
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct RootVCViewRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> RootVC {
        return RootVC()
    }
    
    func updateUIViewController(_ uiViewController: RootVC, context: Context) {
    }
}

@available(iOS 13.0, *)
struct PurchaseVC_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            RootVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
            .edgesIgnoringSafeArea(.all)
            RootVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
            .edgesIgnoringSafeArea(.all)
            RootVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}
#endif
