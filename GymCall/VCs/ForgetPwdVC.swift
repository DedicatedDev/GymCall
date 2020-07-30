//
//  RootVC.swift
//  GymCall
//
//  Created by FreeBird on 5/15/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import UIKit
import Stevia

class ForgetPwdVC: UIViewController {

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
    
    let emailTF:ATCTextField = {
        let b = ATCTextField(psEnabled: false)
        b.layer.borderColor = UIColor.gray.cgColor
        b.layer.borderWidth = 1
        b.height(45)
        b.placeholder = "    Enter your Email address"
        b.textAlignment = .natural
        b.layer.cornerRadius = 22.5
        
        return b
    }()
    
    let emailCaption : UILabel = {
        let b = UILabel(psEnabled: false)
        b.text = "Email"
        b.textColor = MainColors.BtnColor
        b.font = UIFont(name: FontNames.OpenSansSemiBold, size: 18)
        
        return b
    }()
    
    let newPwdBtn: UIButton = {
        let b = UIButton(psEnabled: false)
        b.backgroundColor = MainColors.BtnColor
        b.setTitle("New Password", for: .normal)
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
            view.addSubview(newPwdBtn)
            view.addSubview(emailTF)
            view.addSubview(backImgContainer)
            view.addSubview(emailCaption)
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
            emailTF.top(65%)
            emailTF.width(70%)
        
            emailCaption.bottomAnchor.constraint(equalTo: emailTF.topAnchor, constant:-10).isActive = true
            align(lefts:[emailTF,emailCaption])
        
            newPwdBtn.centerHorizontally()
            coloredLogo.centerHorizontally()
            coloredLogo.top(50)
            newPwdBtn.bottom(8%)

            emailTF.centerHorizontally()
        
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
        
        newPwdBtn.addTarget(self, action: #selector(tryNewPwd), for: .touchDown)
        
    }
    
    @objc func tryNewPwd(){
        
        NetWorkManager.shared.resetPasscode(with: emailTF.text ?? "") { (result) in
            
            switch result{
            case.success(let msg):
                self.view.makeToast(msg)
            case.failure(let msg):
                self.view.makeToast(msg.localizedDescription)
            }
        }
    }
  
    
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct ForgetPwdVCViewRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ForgetPwdVC {
        return ForgetPwdVC()
    }
    
    func updateUIViewController(_ uiViewController: ForgetPwdVC, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ForgetPwdVC_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            ForgetPwdVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
            .edgesIgnoringSafeArea(.all)
            ForgetPwdVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
            .edgesIgnoringSafeArea(.all)
            ForgetPwdVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}
#endif
