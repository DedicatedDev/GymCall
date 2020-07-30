//
//  RootVC.swift
//  GymCall
//
//  Created by FreeBird on 5/15/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import UIKit
import Stevia
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class LoginVC: UIViewController {

   
    let coloredLogo:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = MainColors.BtnColor
        l.text = "GymCall"
        l.font = .systemFont(ofSize: 32)
        return l
    }()
    
    let backBtn:UIButton = {
        let l = UIButton()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.setImage(UIImage(systemName: "chevron.left"), for: .normal)
         l.tintColor = MainColors.BtnColor
        return l
    }()
    
    let avatar1 = UIImageView(image: #imageLiteral(resourceName: "excercise"))
    let avatar2 = UIImageView(image: #imageLiteral(resourceName: "yogagirl"))
    let avatar3 = UIImageView(image: #imageLiteral(resourceName: "weight-loss"))
    
    let emailCaption : UILabel = {
        let b = UILabel(psEnabled: false)
        b.text = "Email"
        b.textColor = MainColors.BtnColor
        b.font = UIFont(name: FontNames.OpenSansSemiBold, size: 18)
        return b
    }()
    let emailTF:ATCTextField = {
        let b = ATCTextField(psEnabled: false)
        b.layer.borderColor = UIColor.gray.cgColor
        b.layer.borderWidth = 1
        b.height(45)
        b.layer.cornerRadius = 22.5
        
        return b
    }()
    
    let pwdCaption : UILabel = {
        let b = UILabel(psEnabled: false)
        b.text = "Password"
        b.textColor = MainColors.BtnColor
        b.font = UIFont(name: FontNames.OpenSansSemiBold, size: 18)
        
        
        return b
    }()
    
    let pwdTF:ATCTextField = {
        let b = ATCTextField(psEnabled: false)
        b.layer.borderColor = UIColor.gray.cgColor
        b.layer.borderWidth = 1
        b.height(45)
        b.layer.cornerRadius = 22.5
        b.isSecureTextEntry = true
        
        return b
    }()
    
    let logInBtn: UIButton = {
        let b = UIButton(psEnabled: false)
        b.backgroundColor = MainColors.BtnColor
        b.setTitle("Login", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.width(205)
        b.height(45)
        b.layer.cornerRadius = 22.5
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
        setupView()
        setupAction()
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    func setupView(){
            
            view.backgroundColor = .white
            view.addSubview(coloredLogo)
            view.addSubview(logInBtn)
            view.addSubview(emailTF)
            view.addSubview(backImgContainer)
            view.addSubview(emailCaption)
            view.addSubview(pwdTF)
            view.addSubview(pwdCaption)
        
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

            emailTF.top(56%)
            emailTF.width(70%)
            
            pwdTF.width(70%)
            pwdTF.centerHorizontally()
            
            pwdCaption.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant:20).isActive = true
            pwdTF.topAnchor.constraint(equalTo: pwdCaption.bottomAnchor, constant: 10).isActive = true
            align(lefts:[emailTF,pwdCaption])
        
            emailCaption.bottomAnchor.constraint(equalTo: emailTF.topAnchor, constant:-10).isActive = true
            align(lefts:[emailTF,emailCaption])
        
            logInBtn.centerHorizontally()
            coloredLogo.centerHorizontally()
            coloredLogo.top(50)
            logInBtn.bottom(8%)

            emailTF.centerHorizontally()
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(backBtn)
        backBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor,constant: 47).isActive = true
        backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive = true
        
        backBtn.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        
        }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupAction(){
        
        logInBtn.addTarget(self, action: #selector(tryLogin), for: .touchDown)
        
    }
    
    @objc func tryLogin(){
        
        NetWorkManager.shared.login(with: emailTF.text!, passcode: pwdTF.text!) { (result) in
            
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                   NetWorkManager.shared.RegisterDevice()
                   let vc = ActivitySelectorVC()
                   self.navigationController?.pushViewController(vc, animated: true)
                }
                        
            case .failure(let err):
                
                let msg:String = Utils.FirebaseErrAnalysis(err: err)
                self.view.makeToast(msg)
            }
        }
    }
}




#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct LoginVCViewRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> LoginVC {
        return LoginVC()
    }
    
    func updateUIViewController(_ uiViewController: LoginVC, context: Context) {
    }
}

@available(iOS 13.0, *)
struct LoginVC_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            LoginVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
            .edgesIgnoringSafeArea(.all)
            LoginVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
            .edgesIgnoringSafeArea(.all)
            LoginVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}
#endif
