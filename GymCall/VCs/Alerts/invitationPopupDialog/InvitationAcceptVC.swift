//
//  iniviteAcceptAlert.swift
//  GymCall
//
//  Created by FreeBird on 6/20/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

protocol InvitationAcceptVCDelegate {
    func agreeContent()
    func declineContent()
}

class InvitationAcceptVC: UIViewController {
    
    /// The PopupDialog this view is contained in
    /// Note: this has to be weak, otherwise we end up
    /// creating a retain cycle!
    public weak var popup: PopupDialog?
    var delegate:InvitationAcceptVCDelegate?
    
    
    // MARK: Private
    
    // We will use this instead to reference our
    // controllers view instead of `view`
    fileprivate var baseView: InvitationPopView {
        return view as! InvitationPopView
    }
    
    // MARK: View related
    
    // Replace the original controller view
    // with our dedicated view
    override func loadView() {
        view = InvitationPopView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        baseView.accepBtn.addTarget(self, action: #selector(agreeContent), for: .touchUpInside)
        baseView.declineBtn.addTarget(self, action: #selector(declineContent), for: .touchUpInside)
        
    }
    func setMsg(with msgText:String){
        baseView.msg = msgText
    }
    
    @objc func agreeContent(){
        dismiss(animated: true) {
            self.delegate?.agreeContent()
        }
       
    }
    
    @objc func declineContent(){
        dismiss(animated: true, completion: {
            self.delegate?.declineContent()
        })
       
    }
}
