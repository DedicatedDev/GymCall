//
//  AlertViewController.swift
//  GymCall
//
//  Created by FreeBird on 5/18/20.
//  Copyright © 2020 GymCall. All rights reserved.
//

import UIKit
import Stevia
import FirebaseAuth
import Firebase
import FirebaseDatabase
import Kingfisher

struct FriendModel{
    let id:Int
    let imageLink:String?
    let userName:String?
    let tempImg:UIImage?
}
var alphaBeDic = [0:"a",1:"b",2:"c",3:"d"]
protocol  InviteVCDelegate {

    func sendInvite()
    func startedAsInvite()
    func finishInvite()

}
class InviteVC: UIViewController {
    
    var delegate:InviteVCDelegate?
    var invitedFriendsList:[UserForRoom] = []
    let startBtn : UIButton = {
          
          let b = UIButton(psEnabled: false)
          b.backgroundColor = UIColor(hexString: "#FD7028")
          b.setTitle("Start", for: .normal)
          b.setTitleColor(.white, for: .normal)
          b.titleLabel?.font = UIFont(name: FontNames.OpenSansBold, size: 21)
          return b
          
      }()
      
    var dataSrc:[UserForRoom] = []{
        didSet{
            friendList.reloadData()
        }
    }
    
    var originalSrc:[UserForRoom] = []
    var filteredSrc:[UserForRoom] = []
    var isSearching:Bool = false
    
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
    
    let searchBar:ATCTextField = {
        
        let s = ATCTextField(psEnabled: false)
        s.backgroundColor = .white
        s.layer.cornerRadius = 24
        s.placeholder = "Search for your friends"
    
        return s
    }()
    
    let friendList:UITableView = {
        
        let t = UITableView(psEnabled: false)
        let backgroundView = GradientView(gradientStartColor: UIColor(hexString: "#CB6969"), gradientEndColor: UIColor(hexString: "#FFBE95"))
        t.backgroundView?.addSubview(backgroundView)
        backgroundView.fillContainer()
        t.backgroundColor = UIColor(hexString: "#4D8AC6")
        t.separatorStyle = .none
        return t

    }()
    
    let container:UIView = {
        let v = UIView(psEnabled: false)
        v.backgroundColor = UIColor(hexString: "#D2D0D0")
        v.layer.cornerRadius = 38
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFriendsList()
        view.backgroundColor = .clear
        setupView()
        friendList.dataSource = self
        friendList.delegate = self
        friendList.register(FriendItemCell.self, forCellReuseIdentifier: FriendItemCell.reusableIdentifier)
        setupAction()
    }
    
    func setupView(){

        view.addSubview(container)
        view.addSubview(friendList)
        view.addSubview(searchBar)
        
        container.height(55%)
        container.left(15)
        container.right(15)
        container.centerHorizontally()
        container.centerVertically()
        container.addSubview(searchBar)
        container.addSubview(friendList)
        friendList.left(0)
        friendList.bottom(0)
        friendList.right(0)
        friendList.layer.cornerRadius = 38
        container.addSubview(startBtn)
        startBtn.height(37)
        startBtn.width(87)
        startBtn.centerHorizontally()
        startBtn.bottom(22)
        startBtn.layer.cornerRadius = 15
     
        container.layout(
            20,
            searchBar,
            14,
            friendList,
            0
        )
    
        searchBar.height(48)
        searchBar.left(15)
        searchBar.right(15)
    }
    
    func setupAction(){
        
        searchBar.delegate = self
        startBtn.addTarget(self, action: #selector(inviteStart), for: .touchDown)
    }
    
    @objc func inviteStart(){
        
        var membersList:[String:Member] = [:]
        let numberOfMembers = invitedFriendsList.count
        for i in 0..<4{
            if i < numberOfMembers{
                 membersList[alphaBeDic[i] ?? "a"] = Member(model: invitedFriendsList[i])
            }else{
                membersList[alphaBeDic[i] ?? "a"] = Member()
            }
           
        }

        let members = Members(a: membersList["a"], b: membersList["b"], c: membersList["c"], d: membersList["d"])
        let roomData = Room(activityType: myStatus.currentActivityType?.rawValue, master: Auth.auth().currentUser?.uid, activityStatus: ActivityProgress.waiting.rawValue, activityDuration: myStatus.activityDuration, members: members)
        
        NetWorkManager.shared.creatRoom(with: roomData){ (result) in
            switch result{
            case .failure(let err):
                print(err.localizedDescription)
            case .success(let id):
                myRoomId = id
                myStatus.meettingId = myRoomId
                self.dismiss(animated: true) {
                    self.delegate?.startedAsInvite()
                }
            }
        }
        
    }
    
    func getFriendsList(){
       
        guard let goal = myStatus.currentActivityType?.rawValue else{
            return
        }
        NetWorkManager.shared.getFriendsList(with: goal) { (result) in
            switch result{
            case .success(let fullList):
                self.dataSrc = fullList
                self.originalSrc = fullList
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

extension InviteVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        dataSrc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendItemCell.reusableIdentifier, for: indexPath) as! FriendItemCell
        cell.item = dataSrc[indexPath.row]
        
        cell.callback = {
            
            if self.invitedFriendsList.count > 4 {
                self.view.makeToast("Already send invitation to four members!")
            }else{
                self.invitedFriendsList.append(self.dataSrc[indexPath.row])
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension InviteVC:UITextFieldDelegate{
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        beginSearch(quary: textField.text ?? "")
        textField.resignFirstResponder()
        return false
    }
        
    func beginSearch(quary:String){
        
        filteredSrc = originalSrc.filter({$0.userName!.uppercased().contains(quary.uppercased())})
        dataSrc = filteredSrc
        friendList.reloadData()
    }
}

class FriendItemCell: UITableViewCell {
    
    static let reusableIdentifier:String = "FriendItemCell"
    

    var callback:(()->Void)?
    var item:UserForRoom?{
        didSet{
            
            if let urlString = item?.imageLink{
                let url = URL(string: urlString)
                userImg.kf.indicatorType = .activity
                userImg.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profile"))
            }
            
            userNameLbl.text = item?.userName ?? ""
        }
    }
    
    let userImg:UIImageView = {
        
        let iv = UIImageView(psEnabled: false)
        iv.width(58)
        iv.height(58)
        iv.layer.cornerRadius = 24
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let userNameLbl:UILabel = {
        
        let l = UILabel(psEnabled: false)
        l.textColor = .black
        return l
    }()
    
    let inviteBtn:UIButton = {
        
        let b = UIButton(psEnabled: false)
        b.setTitle("Invite", for: .normal)
        b.width(61).height(31)
        b.layer.cornerRadius = 15
        b.backgroundColor = .white
        b.setTitleColor(.black, for: .normal)
        
        return b
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        self.backgroundColor = .clear
        self.hstack(userImg,userNameLbl,stack(UIView(),inviteBtn,UIView(),distribution:.equalCentering), spacing: 10, alignment:.fill, distribution: .fill).padLeft(10).padTop(5).padLeft(10).padBottom(5).padRight(10)
    }
    
    func setupAction(){
        
        inviteBtn.isUserInteractionEnabled = true
        inviteBtn.addTarget(self, action: #selector(tryInvite), for: .touchDown)
        
    }
    
    @objc func tryInvite(){
        
        inviteBtn.isUserInteractionEnabled = false
        inviteBtn.setTitle("Invited", for: .normal)
        inviteBtn.backgroundColor = .lightGray
        callback?()
    }

}

//extension InviteVC:IndicatorViewDelegate{
//
//    func gotoFirstScreen() {
//
//        print("okay")
//    }
//
//
//    func finishActivity() {
//
//        let vc = ActivitySelectorVC()
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func endStep(step: Int) {
//        self.delegate?.finishInvite()
//    }
//
//
//}





//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//struct InviteVCViewRepresentable: UIViewControllerRepresentable {
//
//    func makeUIViewController(context: Context) -> InviteVC {
//        return InviteVC()
//    }
//
//    func updateUIViewController(_ uiViewController: InviteVC, context: Context) {
//    }
//}
//
//@available(iOS 13.0, *)
//struct InviteVC_Preview: PreviewProvider {
//    static var previews: some View {
//        return Group {
//            InviteVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
//            .edgesIgnoringSafeArea(.all)
//            InviteVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone SE"))
//            .edgesIgnoringSafeArea(.all)
//            InviteVCViewRepresentable().previewDevice(PreviewDevice(stringLiteral: "iPhone 8"))
//            .edgesIgnoringSafeArea(.all)
//        }
//
//    }
//}
//#endif
