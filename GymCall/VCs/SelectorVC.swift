//
//  Board1.swift
//  GymCall
//
//  Created by FreeBird on 5/17/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import UIKit
import Stevia
import LBTATools
import Kingfisher
import FirebaseAuth
import AVKit

enum ActivityType:String {
    case Bump = "Bump Body"
    case Yoga = "Yoga"
    case FatLoss = "Fat Loss"
}

struct AnimationInfo {
    static var actionedBtnTag:Int = 0
    static var position:[Int] = [0,1,2]
}


class ActivitySelectorVC:UIViewController{
    
    
    let profileImg:UIImageView = {
        
        let iv = UIImageView(psEnabled: false)
        iv.width(50)
        iv.height(50)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 25
        iv.image = #imageLiteral(resourceName: "profile")
        iv.clipsToBounds = true        
        return iv
        
    }()
    
    let timeSelector : DropDown = {
        
        let tf = DropDown(psEnabled: false)
        tf.placeholder = "Country"
        tf.arrowColor = .white
        tf.isSearchEnable = true
        tf.textColor = UIColor(hexString: "#ACB9FB")
        tf.textAlignment = .center
        tf.tintColor = .white
        tf.selectedRowColor = UIColor(hexString: "#ACB9FB")
        tf.cornerRadius = 12
        tf.isSearchEnable = false
        tf.rowTextColor = UIColor(hexString: "#ACB9FB")
        tf.backgroundColor = .clear
        let imgView = UIImageView(image: #imageLiteral(resourceName: "arrow"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16, height: 28))
        imgView.contentMode = .scaleAspectFit
        leftView.addSubview(imgView)
        imgView.fillContainer(5)
        imgView.top(5)
        
        tf.rightView = leftView
//        tf.text = "10 min"
//        tf.optionArray = ["10 min","20 min"]
        tf.backgroundColor = .white
        tf.font = UIFont(name: FontNames.OpenSansBold, size: 12)
        tf.placeholder = "10 Minutes"
        
        return tf
    }()
    
    let activityImg1:UIButton = {
        
        let iv = UIButton()
        
        iv.setImage(#imageLiteral(resourceName: "excercise"), for: .normal)
        iv.layer.cornerRadius = 65
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        
        return iv
        
    }()
    
    let activityImg2:UIButton = {
        
        let iv = UIButton()
        iv.setImage(#imageLiteral(resourceName: "yogagirl"), for: .normal)
        iv.layer.cornerRadius = 65
        
        iv.imageView?.contentMode = .scaleAspectFit
        iv.imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        iv.backgroundColor = .white
        return iv
        
    }()
    
    let activityImg3:UIButton = {
        
        let iv = UIButton()
        
        iv.setImage(#imageLiteral(resourceName: "weight-loss"), for: .normal)
        iv.imageView?.contentMode = .scaleAspectFill
        
        iv.layer.cornerRadius = 65
        iv.backgroundColor = .white
        return iv
        
    }()
    
    
    let subContainer:UIView = {
        
        let v = UIView(psEnabled: false)
        
        return v
    }()
    
    let titlLbl:UILabel = {
        
        let l = UILabel(psEnabled: false)
        l.text = "Choose your \n Activity"
        l.numberOfLines = 2
        l.font = UIFont(name: FontNames.OpenSansBold, size: 25)
        l.textColor = .black
        l.textAlignment = .center
        return l
        
    }()
    let caption:UILabel = {
        
        let l = UILabel(psEnabled: false)
        
        l.font = UIFont(name: FontNames.OpenSansBold, size: 30)
        l.textColor = .white
        l.numberOfLines = 0
        l.height(41)
        return l
        
    }()
    
    let contentLbl:UITextView = {
        
        let l = UITextView(psEnabled: false)
        l.font = UIFont(name: FontNames.OpenSansBold, size: 15)
        l.isEditable = false
        l.backgroundColor = .clear
        l.textColor = .white
        l.textAlignment = .center
        l.sizeToFit()
        l.isScrollEnabled = false
        
        return l
    }()
    
    let shapeLayer = CAShapeLayer()
    
    
    
    
    let gradientView:GradientView = {
        
        let v = GradientView(gradientStartColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), gradientEndColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) )
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.borderColor = UIColor(hexString: "#707070").cgColor
        v.layer.cornerRadius = 108
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        return v
        
    }()
    
    let superView = UIView(psEnabled: false)
    ///parameters for animation
    let radius:CGFloat = 510
    var ang:CGFloat = 0.0
    var centre1:CGPoint = CGPoint(x: 0, y: 0)
    var centre2:CGPoint = CGPoint(x: 0, y: 0)
    var centre3:CGPoint = CGPoint(x: 0, y: 0)
    var circleCenter = CGPoint(x: 0, y: 0)
    let backgroundLayer = CAShapeLayer()
    let gradient = CAGradientLayer()
    var themePath = UIBezierPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         var optionArrayString:[String] = []
         myStatus.activityDuration = "\(10) Minutes"
        
        for i in stride(from: 10, to: 100, by: 10) {
            optionArrayString.append("\(i) Minutes")
        }
      
        timeSelector.optionArray = optionArrayString
        
     
        view.backgroundColor = .white
               self.navigationController?.navigationBar.isHidden = true
               calculationParameters()
               themePath = UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: 0 , endAngle:2*CGFloat.pi, clockwise: true)
               gradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
               backgroundLayer.path = themePath.cgPath
               
               // basicTheme()
               YogaTheme()
               
               gradient.startPoint = CGPoint(x: 1, y: 0)
               gradient.endPoint = CGPoint(x: 1, y: 1)
               gradient.mask = backgroundLayer
               view.layer.addSublayer(gradient)
               
               superView.addSubview(subContainer)
               view.addSubview(superView)
               superView.addSubview(profileImg)
               
               subContainer.bottom(0)
               subContainer.left(0)
               subContainer.right(0)
               subContainer.height(50%)
               superView.fillSuperviewSafeAreaLayoutGuide()
               
               profileImg.top(2%)
               profileImg.left(5%)
               
               superView.addSubview(titlLbl)
               titlLbl.centerHorizontally()
               titlLbl.top(6%)
               
               
               subContainer.addSubview(contentLbl)
               contentLbl.centerInContainer()
               contentLbl.width(70%)
               
               subContainer.addSubview(caption)
               caption.centerHorizontally()
               subContainer.addSubview(timeSelector)
               timeSelector.centerHorizontally()
               timeSelector.width(104)
               timeSelector.height(26)
               
               subContainer.layout(
                   25,
                   timeSelector,
                   25,
                   caption,
                   10,
                   contentLbl,
                   10
               )
               
               view.addSubview(activityImg1)
               activityImg1.frame = CGRect(x: centre1.x - 65 , y: centre1.y - 65, width: 130, height: 130)
               
               view.addSubview(activityImg2)
               activityImg2.frame = CGRect(x: centre2.x - 65 , y: centre2.y - 65, width: 130, height: 130)
               
               view.addSubview(activityImg3)
               activityImg3.frame = CGRect(x: centre3.x - 65 , y: centre3.y - 65, width: 130, height: 130)               
               setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        StreamingManager.shared.resetManager()
       
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
    
    func basicTheme(){
        
        caption.text = "Bump Body"
        contentLbl.text = "This 60-minute addictive workout challenges all of your major muscle groups by using the best weight-room exercises such as squats, presses and curls"
        gradient.colors = [UIColor(hexString: "#ADC0FD").cgColor,
                           UIColor(hexString: "#AB85F2").cgColor]
        
        timeSelector.textColor = UIColor(hexString: "#ADC0FD")
        timeSelector.tintColor = UIColor(hexString: "#ADC0FD")
        timeSelector.rowTextColor = UIColor(hexString: "#ADC0FD")
        
        
    }
    
    func YogaTheme(){
        
        
        caption.text = "Yoga"
        contentLbl.text = "A yoga session can burn between 180 and 460 calories, Here is 15 minute Yoga exercise group exercise. \n Equipment Requirement:\n None"
        
        gradient.colors = [UIColor(hexString: "#90CFFD").cgColor,
                           UIColor(hexString: "#6FADE2").cgColor]
        
        timeSelector.textColor = UIColor(hexString: "#90CFFD")
        timeSelector.tintColor = UIColor(hexString: "#90CFFD")
        timeSelector.rowTextColor = UIColor(hexString: "#90CFFD")
    }
    
    func FatLossTheme(){
        
        caption.text = "Fat Loss"
        contentLbl.text = "20 Minute exercise to allow burn as much calories as possible. On average each person burn around 200 to 300 calories during this 20 minute "
        gradient.colors = [UIColor(hexString: "#FFBE95").cgColor,
                           UIColor(hexString: "#CB6969").cgColor]
        
        timeSelector.textColor = UIColor(hexString: "#FFBE95")
        timeSelector.tintColor = UIColor(hexString: "#FFBE95")
        timeSelector.rowTextColor = UIColor(hexString: "#FFBE95")
    }
    
    
    func calculationParameters(){
        
        
        let r:CGFloat = 510
        let w:CGFloat = view.frame.width
        let h:CGFloat = view.frame.height
        let alpha:CGFloat = asin(0.5*w/r)
        let centerX:CGFloat = w/2
        let centerY:CGFloat = 0.45*h + r
        let center:CGPoint = CGPoint(x: centerX, y: centerY)
        
        let delta:CGFloat = tan(alpha)*0.5*w
        let firstPosition:CGPoint = CGPoint(x: 0, y: 0.45 * h + delta/2)
        centre1 = firstPosition
        
        let secondPostion:CGPoint = CGPoint(x: w/2, y: 0.45*h)
        centre2 = secondPostion
        
        let thirdPostion:CGPoint = CGPoint(x: w, y: 0.45 * h + delta/2)
        centre3 = thirdPostion
        
        ang = alpha
        circleCenter = center
        
        
    }
    
    
    
    func rotatetoRightView(){
        
        
        let startAngle:CGFloat = -0.5*CGFloat.pi - ang
        let endAngle = -0.5*CGFloat.pi
        
        let startAngle1:CGFloat = -0.5*CGFloat.pi
        let endAngle1:CGFloat = -0.5*CGFloat.pi + ang
        
        let startAngle2:CGFloat = -0.5*CGFloat.pi + ang
        let endAngle2:CGFloat = -0.5*CGFloat.pi + 2*ang
        
        let circlePath1 = UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: startAngle , endAngle:endAngle, clockwise: true)
        
        let circlePath2 =  UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: startAngle1 , endAngle: endAngle1, clockwise: true)
        
        let circlePath3 =  UIBezierPath( arcCenter: circleCenter, radius: radius, startAngle: startAngle2 , endAngle:endAngle2, clockwise: true)
        
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 1 // In seconds
        animation.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation.path = circlePath1.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg1.layer.add(animation, forKey: "myAnimation")
        activityImg1.frame.origin.x = circlePath1.cgPath.currentPoint.x - activityImg1.frame.width / 2
        activityImg1.frame.origin.y = circlePath1.cgPath.currentPoint.y - activityImg1.frame.height / 2
        
        
        let animation1 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation1.duration = 1// In seconds
        animation1.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation1.path = circlePath2.cgPath
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg2.layer.add(animation1, forKey: "myAnimation1")
        activityImg2.frame.origin.x = circlePath2.cgPath.currentPoint.x - activityImg3.frame.width / 2
        activityImg2.frame.origin.y = circlePath2.cgPath.currentPoint.y - activityImg3.frame.height / 2
        
        
        let animation2 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation2.duration = 1 // In seconds
        animation2.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation2.path = circlePath3.cgPath
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg3.layer.add(animation2, forKey: "myAnimation2")
        activityImg3.frame.origin.x = circlePath3.cgPath.currentPoint.x - activityImg3.frame.width / 2
        activityImg3.frame.origin.y = circlePath3.cgPath.currentPoint.y - activityImg3.frame.height / 2
        
        AnimationInfo.position[0] = 1
        AnimationInfo.position[1] = 2
        AnimationInfo.position[2] = -1
        
    }
    
    func rotatetoLeft(){
        
        
        let startAngle1:CGFloat = -0.5*CGFloat.pi
        let endAngle1 = -0.5*CGFloat.pi - ang
        
        let startAngle2:CGFloat = -0.5*CGFloat.pi + ang
        let endAngle2:CGFloat =  -0.5*CGFloat.pi
        
        let startAngle:CGFloat = -0.5*CGFloat.pi - ang
        let endAngle:CGFloat = -0.5*CGFloat.pi - 2*ang
        
        let circlePath1 = UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: startAngle , endAngle:endAngle, clockwise: false)
        
        let circlePath2 =  UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: startAngle1 , endAngle: endAngle1, clockwise: false)
        
        let circlePath3 =  UIBezierPath( arcCenter: circleCenter, radius: radius, startAngle: startAngle2 , endAngle:endAngle2, clockwise: false)
        
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 1 // In seconds
        animation.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation.path = circlePath1.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg1.layer.add(animation, forKey: "myAnimation")
        activityImg1.frame.origin.x = circlePath1.cgPath.currentPoint.x - activityImg1.frame.width / 2
        activityImg1.frame.origin.y = circlePath1.cgPath.currentPoint.y - activityImg1.frame.height / 2
        
        
        let animation1 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation1.duration = 1// In seconds
        animation1.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation1.path = circlePath2.cgPath
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg2.layer.add(animation1, forKey: "myAnimation1")
        activityImg2.frame.origin.x = circlePath2.cgPath.currentPoint.x - activityImg3.frame.width / 2
        activityImg2.frame.origin.y = circlePath2.cgPath.currentPoint.y - activityImg3.frame.height / 2
        
        
        let animation2 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation2.duration = 1 // In seconds
        animation2.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation2.path = circlePath3.cgPath
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg3.layer.add(animation2, forKey: "myAnimation2")
        activityImg3.frame.origin.x = circlePath3.cgPath.currentPoint.x - activityImg3.frame.width / 2
        activityImg3.frame.origin.y = circlePath3.cgPath.currentPoint.y - activityImg3.frame.height / 2
        
        AnimationInfo.position[0] = -1
        AnimationInfo.position[1] = 0
        AnimationInfo.position[2] = 1
        
    }
    
    
    func rotatetoMiddel(){
        
        let startAngle:CGFloat = -0.5*CGFloat.pi
        let endAngle = -0.5*CGFloat.pi - ang
        
        let startAngle1:CGFloat = -0.5*CGFloat.pi + ang
        let endAngle1:CGFloat =  -0.5*CGFloat.pi
        
        let startAngle2:CGFloat = -0.5*CGFloat.pi + 2*ang
        let endAngle2:CGFloat = -0.5*CGFloat.pi + ang
        
        let circlePath1 = UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: startAngle , endAngle:endAngle, clockwise: false)
        
        let circlePath2 =  UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: startAngle1 , endAngle: endAngle1, clockwise: false)
        
        let circlePath3 =  UIBezierPath( arcCenter: circleCenter, radius: radius, startAngle: startAngle2 , endAngle:endAngle2, clockwise: false)
        
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 1 // In seconds
        animation.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation.path = circlePath1.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg1.layer.add(animation, forKey: "myAnimation")
        activityImg1.frame.origin.x = circlePath1.cgPath.currentPoint.x - activityImg1.frame.width / 2
        activityImg1.frame.origin.y = circlePath1.cgPath.currentPoint.y - activityImg1.frame.height / 2
        
        
        let animation1 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation1.duration = 1// In seconds
        animation1.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation1.path = circlePath2.cgPath
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg2.layer.add(animation1, forKey: "myAnimation1")
        activityImg2.frame.origin.x = circlePath2.cgPath.currentPoint.x - activityImg3.frame.width / 2
        activityImg2.frame.origin.y = circlePath2.cgPath.currentPoint.y - activityImg3.frame.height / 2
        
        
        let animation2 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation2.duration = 1 // In seconds
        animation2.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation2.path = circlePath3.cgPath
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg3.layer.add(animation2, forKey: "myAnimation2")
        activityImg3.frame.origin.x = circlePath3.cgPath.currentPoint.x - activityImg3.frame.width / 2
        activityImg3.frame.origin.y = circlePath3.cgPath.currentPoint.y - activityImg3.frame.height / 2
        
        AnimationInfo.position[0] = 0
        AnimationInfo.position[1] = 1
        AnimationInfo.position[2] = 2
        
    }
    
    
    func rotatetoMiddel1(){
        
        let startAngle2:CGFloat = -0.5*CGFloat.pi
        let endAngle2 = -0.5*CGFloat.pi + ang
        
        let startAngle1:CGFloat = -0.5*CGFloat.pi - ang
        let endAngle1:CGFloat =  -0.5*CGFloat.pi
        
        let startAngle:CGFloat = -0.5*CGFloat.pi - 2*ang
        let endAngle:CGFloat = -0.5*CGFloat.pi - ang
        
        let circlePath1 = UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: startAngle , endAngle:endAngle, clockwise: true)
        
        let circlePath2 =  UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: startAngle1 , endAngle: endAngle1, clockwise: true)
        
        let circlePath3 =  UIBezierPath( arcCenter: circleCenter, radius: radius, startAngle: startAngle2 , endAngle:endAngle2, clockwise: true)
        
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 1 // In seconds
        animation.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation.path = circlePath1.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg1.layer.add(animation, forKey: "myAnimation")
        activityImg1.frame.origin.x = circlePath1.cgPath.currentPoint.x - activityImg1.frame.width / 2
        activityImg1.frame.origin.y = circlePath1.cgPath.currentPoint.y - activityImg1.frame.height / 2
        
        
        let animation1 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation1.duration = 1// In seconds
        animation1.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation1.path = circlePath2.cgPath
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg2.layer.add(animation1, forKey: "myAnimation1")
        activityImg2.frame.origin.x = circlePath2.cgPath.currentPoint.x - activityImg3.frame.width / 2
        activityImg2.frame.origin.y = circlePath2.cgPath.currentPoint.y - activityImg3.frame.height / 2
        
        
        let animation2 = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation2.duration = 1 // In seconds
        animation2.repeatCount = 1 //At maximum it could be MAXFLOAT if you want the animation to seem to loop forever
        animation2.path = circlePath3.cgPath
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)  //Optional
        
        activityImg3.layer.add(animation2, forKey: "myAnimation2")
        activityImg3.frame.origin.x = circlePath3.cgPath.currentPoint.x - activityImg3.frame.width / 2
        activityImg3.frame.origin.y = circlePath3.cgPath.currentPoint.y - activityImg3.frame.height / 2
        
        AnimationInfo.position[0] = 0
        AnimationInfo.position[1] = 1
        AnimationInfo.position[2] = 2
        
    }
    
    @objc func additionalAction(){
        
        let vc = ProfileVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        //            let alert = UIAlertController(title: "GymCall" , message: nil, preferredStyle: .actionSheet)
        //
        //                let addAction = UIAlertAction(title: "Logout?", style: .default) { (action) in
        //
        //                    do{
        //                        try Auth.auth().signOut()
        //                        self.view.makeToast("Sussessfully logout!")
        //                    }catch{
        //                        self.view.makeToast("Something went wrong....")
        //                    }
        //
        //
        //
        ////                    let vc = UserSavedRecipesVC()
        ////                 //   self.planOption.currentDate = self.fromDate
        ////                    vc.planOptions = self.planOption
        ////                    vc.delegate = self
        ////                    self.present(vc, animated: true, completion: nil)
        ////                    print("okahy")
        //                }
        //
        ////                let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
        ////
        ////                    //self.menuDelegate?.deleteCurrentItem()
        ////                    guard self.currentIndexPath != nil else{
        ////                        return
        ////                    }
        ////                    self.deleteItem(indexPath: self.currentIndexPath!)
        ////
        ////                }
        ////
        ////                let viewAction = UIAlertAction(title: "View Recipe", style: .default) { (action) in
        ////
        ////                    guard self.currentIndexPath != nil else{
        ////                        return
        ////                    }
        ////
        ////                    guard self.currentIndexPath?.row != nil else{
        ////                        return
        ////                    }
        ////                    guard self.currentIndexPath?.section != nil else{
        ////                        return
        ////                    }
        ////                    self.fetchRecipeInfo(with: self.dataSrc[self.currentIndexPath!.section][self.currentIndexPath!.row].id)
        ////                }
        ////                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        ////
        ////                    print("delete")
        ////                }
        //
        //                alert.addAction(addAction)
        ////                alert.addAction(viewAction)
        ////                alert.addAction(deleteAction)
        ////                alert.addAction(cancelAction)
        //                self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func setupAction(){
        
        
        timeSelector.didSelect { (selectedTitle, id, index) in
        
            myStatus.activityDuration = selectedTitle
        
        }
        
        
        
        activityImg1.addTarget(self, action: #selector(activityOne), for: .touchDown)
        activityImg2.addTarget(self, action: #selector(activityTwo), for: .touchDown)
        activityImg3.addTarget(self, action: #selector(activityThree), for: .touchDown)
        
        profileImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(additionalAction))
        profileImg.addGestureRecognizer(tap)
        
        NetWorkManager.shared.getUserInfo { (result) in
            
            switch result{
            case.success(let user):
                currentUserInfo = user
                DispatchQueue.main.async {
                    self.profileImg.kf.indicatorType = .activity
                    let url = URL(string: user.imageLink)
                    self.profileImg.kf.setImage(
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
                
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
        
    }
    
    
    @objc func activityOne(){
        
        AnimationInfo.actionedBtnTag = 0
        controller()
        
        UIView.animate(withDuration: 1) {
            self.basicTheme()
        }
    }
    
    @objc func activityTwo(){
        
        AnimationInfo.actionedBtnTag = 1
        controller()
        UIView.animate(withDuration: 1) {
            self.YogaTheme()
        }
        
    }
    
    @objc func activityThree(){
        
        AnimationInfo.actionedBtnTag = 2
        controller()
        UIView.animate(withDuration: 1) {
            self.FatLossTheme()
        }
        
    }
    
    func controller(){
    
        switch AnimationInfo.actionedBtnTag {
        case 0:
            switch AnimationInfo.position[0] {
            case 0:
                rotatetoRightView()
                
            case 1:
                openActivity(type: ActivityType.Bump)
                myStatus.currentActivityType = .Bump
            default:
                print("okay")
            }
        case 1:
            switch AnimationInfo.position[1] {
            case 0:
                rotatetoMiddel1()
            case 1:
                openActivity(type: ActivityType.Yoga)
                myStatus.currentActivityType = .Yoga
            case 2:
                rotatetoMiddel()
            default:
                print("okay")
            }
        case 2:
            switch AnimationInfo.position[2] {
            case 0:
                print("something went wrong")
            case 1:
                openActivity(type: ActivityType.FatLoss)
                myStatus.currentActivityType = .FatLoss
            case 2:
                rotatetoLeft()
            default:
                print("what happened")
            }
        default:
            print("is it finished?")
        }
        
    }
    
    func openActivity(type:ActivityType){
        
        let vc = StartActivityVC()
        vc.activityType = type
        myStatus.currentActivityType = type
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct ActivitySelectorVCRepresentable: UIViewRepresentable {
//
//    func makeUIView(context: Context) -> UIView {
//
//        return ActivitySelectorVC().view
//    }
//
//    func updateUIView(_ view: UIView, context: Context) {
//
//    }
//}
//
//@available(iOS 13.0, *)
//struct ArticleCellView_Preview: PreviewProvider {
//    static var previews: some View {
//
//        ActivitySelectorVCRepresentable().previewLayout(.fixed(width: 375, height: 1360))
//
//    }
//}
//
//#endif
////
