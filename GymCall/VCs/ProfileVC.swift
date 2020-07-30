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

class ProfileVC: UIViewController{
    
    var userInfo:UserMainInfo?{
        didSet{
            DispatchQueue.main.async {
            
                self.fullnameTF.text = self.userInfo?.fullName
                self.usernameTF.text = self.userInfo?.userName
                self.goalTF.text = self.userInfo?.goal
                self.weightTF.text = self.userInfo?.weight
                self.emailTF.text = self.userInfo?.email
                self.ageTF.text = self.userInfo?.age
                self.uploadedImageLink = self.userInfo?.imageLink  ?? ""
           
                self.profileImgView.kf.indicatorType = .activity
                let url = URL(string: self.userInfo?.imageLink ?? "")
                self.profileImgView.kf.setImage(
                    with: url,
                    placeholder:  #imageLiteral(resourceName: "profile"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                ]) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
            }
            
        }
    }
    
    
    let imagePicker = UIImagePickerController()
    lazy var scrollView: UIScrollView = {
            let sv = UIScrollView()
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.showsHorizontalScrollIndicator = false
            sv.contentInsetAdjustmentBehavior = .never
            sv.isScrollEnabled = true
            return sv
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
        iv.layer.cornerRadius = 110
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
  
         
         return b
     }()
    
    let goalCaption : UILabel = {
         let b = UILabel(psEnabled: false)
         b.text = "Goal"
         b.textColor = MainColors.BtnColor
         b.font = UIFont(name: FontNames.OpenSansSemiBold, size: 18)
         
         
         return b
     }()
     
//     let goalTF:ATCTextField = {
//         let b = ATCTextField(psEnabled: false)
//         b.layer.borderColor = UIColor.gray.cgColor
//         b.layer.borderWidth = 1
//         b.height(45)
//         b.layer.cornerRadius = 22.5
//
//
//         return b
//     }()
//
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
         b.textAlignment = .center
         b.layer.cornerRadius = 22.5

         
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
         b.textAlignment = .center
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
     
     let emailTF:ATCTextField = {
         let b = ATCTextField(psEnabled: false)
         b.layer.borderColor = UIColor.gray.cgColor
         b.layer.borderWidth = 1
         b.height(45)
         b.layer.cornerRadius = 22.5
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
    

    
    let DoneBtn: UIButton = {
        let b = UIButton(psEnabled: false)
        b.backgroundColor = MainColors.BtnColor
        b.setTitle("Done", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.width(205)
        b.height(45)
        b.layer.cornerRadius = 22.5
        return b
    }()
    
    let logoutBtn: UIButton = {
        let b = UIButton(psEnabled: false)
        b.setTitle("logout", for: .normal)
        b.setTitleColor(MainColors.BtnColor, for: .normal)
        b.width(205)
        b.height(45)
        return b
    }()
    
    let itemContainer:UIView = {
        
        let v = UIView(psEnabled: false)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
       setData()
       setupAction()
    }
    
    func setData(){
        
        
        NetWorkManager.shared.getUserInfo { (result) in
            
            switch result{
            case.success(let userInfo):
                self.userInfo = userInfo
            case.failure(let err):
            
                self.view.makeToast(err.localizedDescription)
            }
        }
        
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
   
       itemContainer.addSubview(goalTF)
       itemContainer.addSubview(goalCaption)
       itemContainer.addSubview(DoneBtn)
        itemContainer.addSubview(logoutBtn)
  
       container.addSubview(itemContainer)
       itemContainer.fillContainer()
       
        NSLayoutConstraint.activate([
        
            itemContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
            itemContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32),
            itemContainer.topAnchor.constraint(equalTo: container.topAnchor),
            itemContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
            
        ])
        
    
        imgWrapper.top(48)
        imgWrapper.centerHorizontally()
        
        
        imgWrapper.width(220)
        imgWrapper.height(220)
        profileImgView.width(220)
        profileImgView.height(220)
        
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
            |-DoneBtn-|,
            10,
            logoutBtn,
           150
        )

        DoneBtn.centerHorizontally()
        imgWrapper.widthAnchor.constraint(equalTo: imgWrapper.heightAnchor).isActive = true
        
        ageTF.width(30%)
        weightTF.width(30%)
        align(lefts: [weightCaption,weightTF])
        align(rights: [weightTF,goalTF])
        align(lefts: [ageCaption,ageTF])
        
        logoutBtn.centerHorizontally()
          
        
    }
    
    func setupAction(){
        
        DoneBtn.addTarget(self, action: #selector(updateProfile), for: .touchDown)
        addPhotoBtn.addTarget(self, action: #selector(tryuploadPhoto), for: .touchDown)
        logoutBtn.addTarget(self, action: #selector(trylogout), for: .touchDown)
        imagePicker.delegate = self
    }
    
    @objc func trylogout(){
        
        do{
            try Auth.auth().signOut()
            let vc = RootVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }catch{
            self.view.makeToast("Something went wrong...")
        }
    }
    @objc func tryuploadPhoto(){
        
        importPhoto()
    }
    
    @objc func updateProfile(){
        
        let updatedInfo = UserMainInfo(fullName: self.fullnameTF.text!, userName: self.usernameTF.text!, goal: self.goalTF.text!, age: self.ageTF.text!, weight: self.weightTF.text!, email: self.emailTF.text!, imageLink:  self.uploadedImageLink)
        
        NetWorkManager.shared.editProfile(userInfo:updatedInfo) { (result) in
           switch result{
           case .success(_):
            print(self.uploadedImageLink)
               let vc = ActivitySelectorVC()
               self.navigationController?.pushViewController(vc, animated:true)
                           
           case .failure(let err):
               print(err.localizedDescription)
               self.view.makeToast("Something went wrong...")
           }
       }
        
        
//        NetWorkManager.shared.askPassword(vc: self) { (result) in
//
//            switch result{
//            case.success(_):
//                print(self.uploadedImageLink)
//                let userInfo = UserMainInfo(fullName: self.fullnameTF.text!, userName: self.usernameTF.text!, goal: self.goalTF.text!, age: self.ageTF.text!, weight: self.weightTF.text!, email: self.emailTF.text!, imageLink:  self.uploadedImageLink)
//
//
//
//            case.failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//
//        if !verificationFields(){
//
//            self.view.makeToast("Please fill out all fields correctly")
//
//        }
        

        
    }
    
    func verificationFields()->Bool{
        
        
        if usernameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || fullnameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwdTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || goalTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || ageTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || weightTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
              
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

extension ProfileVC :UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
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
struct ProfileVCViewRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ProfileVC {
        return ProfileVC()
    }
    
    func updateUIViewController(_ uiViewController: ProfileVC, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ProfileVC_Preview: PreviewProvider {
    static var previews: some View {
        return Group {
            ProfileVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
            .edgesIgnoringSafeArea(.all)
            ProfileVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
            .edgesIgnoringSafeArea(.all)
            ProfileVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}
#endif
