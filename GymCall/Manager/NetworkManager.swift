//
//  NetworkManager.swift
//  BlueWave
//
//  Created by FreeBird on 5/5/20.
//  Copyright © 2020 SuccessResultSdnBhd. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Network


enum FirebaseError: Error {
    case emailAlreadyInUse
    case badRequest
    case unknownError
    case decodingError
    case invalidRefreshToken
    case invalidToken
    case noneExistField
}

class NetWorkManager: NSObject {
    
    static let shared = NetWorkManager()
    let monitor = NWPathMonitor()
    let db = Firestore.firestore()
    var isNetWorkAvailable:Bool = true
    var listeners:[String:ListenerRegistration] = [:]
    override init() {
        super.init()
        
        //setup cache.
        
        
        monitor.pathUpdateHandler = { path in
            
            if path.status != .satisfied {
                
                self.isNetWorkAvailable = false
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NWStatus"), object: self,userInfo: ["isAvailable":false])
                
            } else {
                
                self.isNetWorkAvailable = true
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NWStatus"), object: self,userInfo: ["isAvailable":true])
                
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    
    func register(userInfo:UserMainInfo,passcode:String,completion:@escaping(Result<Bool,Error>) -> ()){
        
        Spinner.start()
        Auth.auth().createUser(withEmail: userInfo.email, password: passcode) { (result, err) in
            Spinner.stop()
            if let err = err {
                
                completion(.failure(err))
                
            } else {
                
                let db = Firestore.firestore()
                let usersDb = db.collection("users")
                let userData = [
                    "email":userInfo.email,
                    "fullName": userInfo.fullName,
                    "udid" : result!.user.uid,
                    "imageLink":userInfo.imageLink,
                    "userName" : userInfo.userName,
                    "goal" : userInfo.goal,
                    "age":userInfo.age,
                    "weight":userInfo.weight,
                    "joined":false,
                    "videoId":0
                    ] as [String : Any]
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let userDoc = usersDb.document(uid)
                userDoc.setData(userData){
                    (error) in
                    
                    if error != nil {
                        completion(.failure(error!))
                    } else {
                        completion(.success(true))
                    }
                    
                }
            }
        }
    }
    
    func editProfile(userInfo:UserMainInfo,completion:@escaping(Result<Bool,Error>) -> ()){
        
        Spinner.start()
        
        let db = Firestore.firestore()
        let usersDb = db.collection("users")
        let userData = [
            "email":userInfo.email,
            "fullName": userInfo.fullName,
            "udid" : Auth.auth().currentUser?.uid ?? "",
            "imageLink":userInfo.imageLink,
            "userName" : userInfo.userName,
            "goal" : userInfo.goal,
            "age":userInfo.age,
            "weight":userInfo.weight,
            "joined":false
            ] as [String : Any]
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userDoc = usersDb.document(uid)
        userDoc.setData(userData as [String : Any],merge:true){
            (error) in
            Spinner.stop()
            if error != nil {
                completion(.failure(error!))
            } else {
                completion(.success(true))
            }
            
        }
    }
    
    
    
    func login(with email:String,passcode:String,completion:@escaping(Result<Bool,Error>) -> ()){
        
        Spinner.start()
        Auth.auth().signIn(withEmail: email, password: passcode) { (result, err) in
            
            if err != nil{
                completion(.failure(err!))
            }else{
                completion(.success(true))
            }
            Spinner.stop()
        }
    }
    
    func uploadingImage(with data:Data, completion:@escaping(Result<String,Error>)->()){
        
        Spinner.start()
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference()
            .child(DataBasePath.profileImgFolder)
            .child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, error) in
            
            if error != nil{
                completion(.failure(error!))
            }
            
            imageReference.downloadURL { (url, err) in
                
                if error != nil{
                    completion(.failure(error!))
                }
                
                guard url != nil else{
                    
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(url!.absoluteString))
                Spinner.stop()
            }
            
        }
    }
    
    
    func getUserInfo ( completion:@escaping(Result<UserMainInfo,Error>)->()) {
        
        Spinner.start()
        let db = Firestore.firestore()
        let docName:String = Auth.auth().currentUser?.uid ?? "user"
        let docRef = db.collection("users").document(docName)
        docRef.getDocument(source: .cache) { (document, error) in
            
            Spinner.stop()
            print(document as Any)
            print("okay")
            
            do {
                guard let user: UserMainInfo = try document?.data(as: UserMainInfo.self) else {return}
                
                completion(.success(user))
            } catch {
                print(error)
                
                completion(.failure(error))
            }
        }
    }
    
    
    func resetPasscode(with email:String,completion:@escaping(Result<String, Error>)->()){
        
        Spinner.start()
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            
            Spinner.stop()
            if err != nil{
                
                completion(.failure(err!))
                
            }else{
                
                completion(.success("Please check your mailbox!"))
                
            }
        }
    }
    
    func RegisterDevice(){
        
        struct DeviceType:Codable{
            let deviceType:String?
            init(model:String) {
                deviceType = model
            }
        }
        
        let deviceType = DeviceType(model: UIDevice.modelName)
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Firestore.firestore().collection("users").document(uid!)
        ref.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            do {
                try ref.setData(from: deviceType, merge: true)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func askPassword(vc: UIViewController,completion:@escaping(Result<Bool,Error>)->()){
        
        let alert = UIAlertController(title: "Blue Wave", message: "Please input your password", preferredStyle: .alert)
        
        alert.addTextField()
        alert.textFields![0].placeholder = "Your Password"
        alert.textFields![0].isSecureTextEntry = true
        alert.textFields![0].textContentType = .password
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
            print("No")
        }))
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            
            Spinner.start()
            if let inputedPasscode:String = alert.textFields![0].text{
                
                NetWorkManager.shared.login(with: Auth.auth().currentUser?.email ?? "1", passcode: inputedPasscode) { (result) in
                    Spinner.stop()
                    switch result{
                    case.success(_):
                        completion(.success(true))
                    case.failure(let err):
                        completion(.failure(err))
                    }
                }
            }else{
                vc.view.makeToast("Please input correct password!")
            }
        }))
        vc.present(alert, animated: true)
    }
    
    
    func creatRoom(with roomData:Room,completion:@escaping(Result<String,Error>)->()){
        
        if Auth.auth().currentUser?.uid != nil{
            
            let ref = Firestore.firestore().collection("Rooms").document()
            do {
                let dic = try roomData.asDictionary()
                ref.setData(dic,merge: true) { (err) in
                    if err != nil{
                        completion(.failure(err!))
                    }
                    completion(.success(ref.documentID))
                }
            } catch{
                print("errr")
            }
            
        }else{
            completion(.failure("failed" as! Error))
        }
    }
    
    
    func deleteRoom(with roomId:String,completion:@escaping(Result<Bool,FirebaseError>)->()) {
        
        if !roomId.isEmpty{
            
            Firestore.firestore().collection("Rooms").document(roomId).delete(){ (err) in
                if err != nil{
                    completion(.failure(.unknownError))
                }
                completion(.success(true))
            }
        }else{
            completion(.failure(.noneExistField))
        }
    }
    
    func getFriendsList(with myActivityType:String, completion:@escaping(Result<[UserForRoom],FirebaseError>)->()){
        
        if myActivityType.isEmpty{
            completion(.failure(.badRequest))
        }
        
        Spinner.start()
        let myId = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("users").whereField("joined", isEqualTo: false)
            //.whereField("goal", isEqualTo: myActivityType)
            .getDocuments { (snapshots, err) in
            Spinner.stop()
            if err != nil{
                completion(.failure(.unknownError))
            }else{
                var friendsInfo:[UserForRoom] = []
                for document in snapshots!.documents {
                    let user = UserForRoom(model:document.data())
                    if user.udid != myId{
                         friendsInfo.append(user)
                    }
                }
                completion(.success(friendsInfo))
            }
        }
    }
    
    func startListener(id:String,myRoomId :String,completion:@escaping(Result<String,Error>)->()){
        
        print(myRoomId)
        let myListener = db.collection("Rooms").document(myRoomId)
        .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                completion(.failure(error!))
                return
            }
            guard let state = snapshot.data()?["activityStatus"] as? String else{
                return
            }
            
            completion(.success(state))
        }
        
        listeners[id] = myListener
    }
    
    func removeListener(with id:String){
        listeners[id]?.remove()
        listeners.removeValue(forKey: id)
    }
    
    func registerActivityProgress(with myRoomId:String, activityProgress:ActivityProgress,completion:@escaping(Result<Bool,Error>)->()){
        
        let modification = ["activityStatus":activityProgress.rawValue]
        db.collection("Rooms").document(myRoomId).setData(modification, merge: true){ (error) in
            if error != nil{
                completion(.failure(error!))
                return
            }else{
                completion(.success(true))
                return 
            }
        }
    }
    
    func getVideoLink(with myRoomId:String,completion:@escaping(Result<String,Error>)->())
    {
        db.collection("Rooms").document(myRoomId).getDocument { (snapshot, err) in
            
            if let document = snapshot {
                guard let videoLink = document.get("videoLink") as? String else{
                    return
                }
                completion(.success(videoLink))
                return
            } else {
                print("Document does not exist in cache")
                completion(.failure(err!))
                return
            }
        }
    }
    
    func checkStauts(with myRoomId:String,completion:@escaping(Result<String,FirebaseError>)->()){
        
       db.collection("Rooms").document(myRoomId).getDocument { (snapshot, err) in
            
            if let document = snapshot {
                guard let progress = document.get("activityStatus") as? String else{
                    completion(.failure(.noneExistField))
                    return
                }
                completion(.success(progress))
                return
            } else {
                print("Document does not exist in cache")
                completion(.failure(.noneExistField))
                return
            }
        }
        
    }
    
    func registerJoinedFlag(with isJoined:Bool,completion:@escaping(Result<Bool,FirebaseError>)->()){
        
        let modification = ["joined":isJoined]
        print(isJoined)
        guard let myId = Auth.auth().currentUser?.uid else{
            return
        }
        db.collection("users").document(myId).setData(modification, merge: true){ (error) in
            if error != nil{
                completion(.failure(.unknownError))
                return
            }else{
                completion(.success(true))
                return
            }
        }
    }
    
}
