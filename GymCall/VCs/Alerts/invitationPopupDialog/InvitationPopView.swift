//
//  InvitationPopView.swift
//  GymCall
//
//  Created by FreeBird on 6/20/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import UIKit


class InvitationPopView: UIView {
    
    let container:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    let gradientView: GradientView = {
        let v = GradientView(gradientStartColor:UIColor(hexString: "#4D8AC6"), gradientEndColor:UIColor(hexString: "#93D2FF") )
        v.translatesAutoresizingMaskIntoConstraints = false
        //v.layer.cornerRadius = 19
        v.clipsToBounds = true
        return v
    }()
    var msg:String = ""{
        didSet{
            msgLbl.text = msg
        }
    }
    var msgLbl:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: FontNames.OpenSansBold, size: 20)
        l.textColor = .white
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    var accepBtn:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = MainColors.BtnColor
        b.setTitle("Yes", for: .normal)
        b.layer.cornerRadius = 20
        b.height(40)
        b.width(90)
        return b
    }()
    
    var declineBtn:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = MainColors.BtnColor
        b.layer.cornerRadius = 20
        b.setTitle("No", for: .normal)
        b.height(40)
        b.width(90)
        return b
    }()
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // Add views
        self.backgroundColor = .clear
        let btnStack = UIStackView(arrangedSubviews: [accepBtn,declineBtn])
        btnStack.axis = .horizontal
        btnStack.spacing = 40.adjusted
        addSubview(gradientView)
        addSubview(msgLbl)
        
        gradientView.addSubview(btnStack)
        btnStack.anchor(top: msgLbl.bottomAnchor, leading: gradientView.leadingAnchor, bottom: gradientView.bottomAnchor, trailing: gradientView.trailingAnchor,padding: UIEdgeInsets(top: 10, left: 57.adjusted, bottom: 20, right: 57.adjusted))
        
        gradientView.addSubview(msgLbl)
        
        msgLbl.anchor(top: topAnchor, leading: leadingAnchor, bottom: btnStack.topAnchor, trailing: trailingAnchor,padding: UIEdgeInsets(top: 20, left: 21, bottom: 10, right: 24))
        
        gradientView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        gradientView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        //action add
        
      
    }
     
   
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct InvitationPopViewRepresentable: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
      
        return InvitationPopView()
    }

    func updateUIView(_ view: UIView, context: Context) {

    }
}

@available(iOS 13.0, *)
struct InvitationPopView_Preview: PreviewProvider {
    static var previews: some View {
        
         InvitationPopViewRepresentable()
    }
}

#endif
