//
//  RegisterVC.swift
//  GymCall
//
//  Created by FreeBird on 5/16/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import UIKit
import Stevia
import Toast_Swift
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RegisterVC: UIViewController{
    
    let imagePicker = UIImagePickerController()
    lazy var scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.showsHorizontalScrollIndicator = false
            sv.contentInsetAdjustmentBehavior = .never
            sv.isScrollEnabled = true
            return sv
    }()
    
    
    let backBtn:UIButton = {
        let l = UIButton()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        l.tintColor = MainColors.BtnColor
        return l
    }()
    
    
    var uploadedImageLink:String = ""
     
    let container:UIView = {
        let v = UIView(psEnabled: false)
       // v.backgroundColor = .blue
        return v
    }()
    
    let imgWrapper:UIView = {
        
        let v = UIView(psEnabled: false)
        v.backgroundColor = .gray
        v.layer.cornerRadius = 110
        return v
    }()
    
    let profileImgView:UIImageView = {
        let iv = UIImageView(psEnabled: false)
        iv.layer.cornerRadius = 70
        iv.image = #imageLiteral(resourceName: "profile")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let addPhotoBtn:UIButton = {
        
        let b = UIButton(psEnabled: false)
        b.setBackgroundImage(#imageLiteral(resourceName: "add-to"), for: .normal)
        b.layer.cornerRadius = 13
        
        return b
        
        
    }()
    
    let fullnameCaption : UILabel = {
         let b = UILabel(psEnabled: false)
         b.text = "Full Name"
         b.textColor = MainColors.BtnColor
         b.font = UIFont(name: FontNames.OpenSansSemiBold, size: 18)
         
         
         return b
     }()
     
     let fullnameTF:ATCTextField = {
         let b = ATCTextField(psEnabled: false)
         b.layer.borderColor = UIColor.gray.cgColor
         b.layer.borderWidth = 1
         b.height(45)
         b.layer.cornerRadius = 22.5
         b.placeholder = "Full Name"
         
         return b
     }()
    
       let usernameCaption : UILabel = {
         let b = UILabel(psEnabled: false)
         b.text = "Username"
         b.textColor = MainColors.BtnColor
         b.font = UIFont(name: FontNames.OpenSansSemiBold, size: 18)
         
         
         return b
     }()
     
     let usernameTF:ATCTextField = {
         let b = ATCTextField(psEnabled: false)
         b.layer.borderColor = UIColor.gray.cgColor
         b.layer.borderWidth = 1
         b.height(45)
         b.layer.cornerRadius = 22.5
         b.placeholder = "Input Your Username"
         
         return b
     }()
    
    let goalCaption : UILabel = {
         let b = UILabel(psEnabled: false)
         b.text = "Goal"
         b.textColor = MainColors.BtnColor
         b.font = UIFont(name: FontNames.OpenSansSemiBold, size: 18)
         
         
         return b
     }()
     
    let goalTF : DropDown = {
        
        let tf = DropDown(psEnabled: false)
        tf.placeholder = "Please select your goal"
        tf.arrowColor = .white
        tf.isSearchEnable = false
        tf.tintColor = .white
        tf.cornerRadius = 22.5
        tf.selectedRowColor = UIColor(hexString: "#FD7028")
        tf.backgroundColor = .clear
        let imgView = UIImageView(image: #imageLiteral(resourceName: "arrow"))
        imgView.tintColor = UIColor(hexString: "#D8D8D8")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30.adjusted, height: 28))
        imgView.contentMode = .scaleAspectFit
        rightView.addSubview(imgView)
        imgView.fillContainer(26)
        imgView.centerVertically()
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15, height: 28))

        tf.rightViewMode = .always
        tf.leftViewMode = .always
        tf.height(45)
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.rightView = rightView
        tf.leftView = leftView
        tf.text = "Yoga"
        tf.optionArray = ["Body Bump","Yoga","Fat Loss"]
        tf.backgroundColor = .white
     //   tf.font = UIFont(name: FontNames.OpenSansBold, size: 12)
    //    tf.placeholder = "8min"
        tf.placeholder = "Choose Your Goal"
        return tf
    }()
    
    let ageCaption : UILabel = {
         let b = UILabel(psEnabled: false)
         b.text = "Age"
         b.textColor = MainColors.BtnColor
         b.font = UIFont(name: FontNames.OpenSansSemiBold, size: 18)
         
         
         return b
     }()
     
     let ageTF:ATCTextField = {
         let b = ATCTextField(psEnabled: false)
         b.layer.borderColor = UIColor.gray.cgColor
         b.layer.borderWidth = 1
         b.height(45)
         b.layer.cornerRadius = 22.5
         b.placeholder = "Your Age"
         
         return b
     }()
    
    let weightCaption : UILabel = {
         let b = UILabel(psEnabled: false)
         b.text = "Weight"
         b.textColor = MainColors.BtnColor
         b.font = UIFont(name: FontNames.OpenSansSemiBold, size: 18)

         
         return b
     }()
     
     let weightTF:ATCTextField = {
         let b = ATCTextField(psEnabled: false)
         b.layer.borderColor = UIColor.gray.cgColor
         b.layer.borderWidth = 1
         b.height(45)
         b.layer.cornerRadius = 22.5
         b.placeholder = "Your Weight"
         return b
     }()
    
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
         b.placeholder = "gmycall@gmail.com"
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
    
    let confirmpwdTF:ATCTextField = {
          let b = ATCTextField(psEnabled: false)
          b.layer.borderColor = UIColor.gray.cgColor
          b.layer.borderWidth = 1
          b.height(45)
          b.layer.cornerRadius = 22.5
          b.isSecureTextEntry = true
          b.placeholder = "Confirm password."
          return b
      }()
    
    let RegisterBtn: UIButton = {
        let b = UIButton(psEnabled: false)
        b.backgroundColor = MainColors.BtnColor
        b.setTitle("Done", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.width(205)
        b.height(45)
        b.layer.cornerRadius = 22.5
        return b
    }()
    
    let itemContainer:UIView = {
        
        let v = UIView(psEnabled: false)
        return v
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
        view.addSubview(scrollView)
        scrollView.addSubview(container)
        
        NSLayoutConstraint.activate([
        
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
        ])
        
        let heightAncher = scrollView.heightAnchor.constraint(equalTo: container.heightAnchor)
        heightAncher.priority = UILayoutPriority(249)
        heightAncher.isActive = true
        
      
       itemContainer.addSubview(imgWrapper)
       itemContainer.addSubview(emailTF)
       itemContainer.addSubview(emailCaption)
       itemContainer.addSubview(fullnameTF)
       itemContainer.addSubview(fullnameCaption)
       itemContainer.addSubview(usernameTF)
       itemContainer.addSubview(usernameCaption)
       itemContainer.addSubview(weightTF)
       itemContainer.addSubview(weightCaption)
       itemContainer.addSubview(ageTF)
       itemContainer.addSubview(ageCaption)
       itemContainer.addSubview(pwdTF)
       itemContainer.addSubview(pwdCaption)
       itemContainer.addSubview(goalTF)
       itemContainer.addSubview(goalCaption)
       itemContainer.addSubview(RegisterBtn)
       itemContainer.addSubview(confirmpwdTF)
       container.addSubview(itemContainer)
       itemContainer.fillContainer()
       
        NSLayoutConstraint.activate([
        
            itemContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
            itemContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32),
            itemContainer.topAnchor.constraint(equalTo: container.topAnchor),
            itemContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
            
        ])
        
        align(lefts: ageTF,pwdTF)
        align(lefts:pwdTF,pwdCaption)
        

        
        imgWrapper.top(48)
        imgWrapper.centerHorizontally()
        
        
        imgWrapper.width(220)
        imgWrapper.height(220)
        profileImgView.width(140)
        profileImgView.height(140)
        
        imgWrapper.addSubview(profileImgView)
        profileImgView.centerInContainer()
        imgWrapper.addSubview(addPhotoBtn)
        addPhotoBtn.width(26)
        addPhotoBtn.height(26)
        addPhotoBtn.right(15)
        addPhotoBtn.bottom(15)
       
        
        imgWrapper.addSubview(addPhotoBtn)

        itemContainer.layout(
            10,
            |-imgWrapper-|,
            10,
            |-fullnameCaption-|,
            10,
            |-fullnameTF-|,
            10,
            |-usernameCaption-|,
            10,
            |-usernameTF-|,
            10,
            |-goalCaption-|,
            10,
            |-goalTF-|,
            10,
            |-10-ageCaption - weightCaption-10-|,
            10,
            |-10-ageTF-weightTF-10-|,
            10,
            |-emailCaption-|,
            10,
            |-emailTF-|,
            10,
            |-pwdCaption-|,
            10,
            |-pwdTF-|,
            20,
            |-confirmpwdTF-|,
            15,
            |-RegisterBtn-|,
           150
        )

        RegisterBtn.centerHorizontally()
        imgWrapper.widthAnchor.constraint(equalTo: imgWrapper.heightAnchor).isActive = true
        
        ageTF.width(30%)
        weightTF.width(30%)
        align(lefts: [weightCaption,weightTF])
        align(rights: [weightTF,goalTF])
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
        
        RegisterBtn.addTarget(self, action: #selector(register), for: .touchDown)
        addPhotoBtn.addTarget(self, action: #selector(tryuploadPhoto), for: .touchDown)
        imagePicker.delegate = self
    }
    
    @objc func tryuploadPhoto(){
        
        importPhoto()
    }
    
    @objc func register(){
        
        if !verificationFields(){
            
            self.view.makeToast("Please fill out all fields correctly")
            
        }
        
        print(uploadedImageLink)
        let userInfo = UserMainInfo(fullName: fullnameTF.text!, userName: usernameTF.text!, goal: goalTF.text!, age: ageTF.text!, weight: weightTF.text!, email: emailTF.text!, imageLink:  uploadedImageLink)
        
        NetWorkManager.shared.register(userInfo: userInfo, passcode: pwdTF.text ?? "") { (result) in
            
            switch result{
            case .success(_):
                
                NetWorkManager.shared.RegisterDevice()
                if let uid = Auth.auth().currentUser?.uid{
                    let pushmanager = PushNotificationManager(userID: uid)
                    pushmanager.registerForPushNotifications()
                }
                
                self.view.makeToast("Success create account")
                let vc = ActivitySelectorVC()
                self.navigationController?.pushViewController(vc, animated:true)
            
            case .failure(let err):
                print(err.localizedDescription)
                self.view.makeToast("Something went wrong...")
            }
            
            
        }
        
    }
    
    func verificationFields()->Bool{
        
        
        if usernameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || fullnameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwdTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmpwdTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || goalTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || ageTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || weightTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
              
            return false
        }
          
        guard confirmpwdTF.text != nil && pwdTF.text != confirmpwdTF.text else {
            return false
        }
        
         return true
        
    }
    
    func importPhoto(){


          imagePicker.sourceType = .photoLibrary

          imagePicker.allowsEditing = true

          self.present(imagePicker, animated: true)
          {
              //After it is complete
          }

      }

}

extension RegisterVC :UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        {
            uploadImage(img: image)
        }else{
            print("Error")
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
  func uploadImage(img:UIImage){
        
        guard let data = img.jpegData(compressionQuality: 1.0) else {
            self.view.makeToast("someting went wrong...")
            return
        }
    
    
    NetWorkManager.shared.uploadingImage(with: data) { (result) in
        
        switch result{
        case.success(let string):
            self.profileImgView.image = img
            print(string)
            self.uploadedImageLink = string
        case.failure(let err):
            
            let errmsgtxt = Utils.FirebaseErrAnalysis(err: err)
            self.view.makeToast(errmsgtxt)
            
            print(err.localizedDescription)
        }
    }

    }
}




#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct RegisterVCViewRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> RegisterVC {
        return RegisterVC()
    }
    
    func updateUIViewController(_ uiViewController: RegisterVC, context: Context) {
    }
}

@available(iOS 13.0, *)
struct RegisterVC_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            RegisterVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
            .edgesIgnoringSafeArea(.all)
            RegisterVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
            .edgesIgnoringSafeArea(.all)
            RegisterVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}
#endif
