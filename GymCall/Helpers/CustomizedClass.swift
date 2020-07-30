//
//  CustomizedClass.swift
//  GymCall
//
//  Created by FreeBird on 5/16/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import UIKit
import AmazonChimeSDK

class GradientView: UIView {

    private let gradient : CAGradientLayer = CAGradientLayer()
    var gradientStartColor: UIColor
    var gradientEndColor: UIColor

    init(gradientStartColor: UIColor, gradientEndColor: UIColor) {
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
        super.init(frame: .zero)
    }
    
    func setColor(gradientStartColor: UIColor, gradientEndColor: UIColor){
        
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
        
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }

    override public func draw(_ rect: CGRect) {
        gradient.frame = self.bounds
        gradient.colors = [gradientEndColor.cgColor, gradientStartColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }
}

class ATCTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class StreamingView: UIView {
    
    private let placeholderLbl:UILabel = {
        let l = UILabel(psEnabled: false)
        l.text = ""
        l.font = UIFont(name: FontNames.OpenSansBold, size: 17)
        l.textColor = UIColor(hexString: "#50514F")
        return l
    }()
    
    var placeholer:String = "Random"{
        didSet{
            if !placeholer.isEmpty{
                placeholderLbl.isHidden = false
                placeholderLbl.text = placeholer
            }else{
                placeholderLbl.isHidden = true
            }
        }
    }
    let renderView:DefaultVideoRenderView = {
        
        let v = DefaultVideoRenderView(psEnabled: false)
        v.layer.cornerRadius = 40
        v.layer.borderWidth = 4
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        v.layer.borderColor = UIColor(hexString: "#ACA4F8").cgColor
        v.backgroundColor = UIColor(hexString: "#E0DEF5")
       
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        addSubview(renderView)
        renderView.fillSuperview()
        addSubview(placeholderLbl)
        placeholderLbl.centerInContainer()
        placeholderLbl.isHidden = false
        placeholderLbl.text = "Random"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

