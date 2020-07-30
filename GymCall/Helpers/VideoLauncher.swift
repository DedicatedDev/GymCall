
//
//  TestRecipeVCHeaderCell.swift
//  Mealz
//
//  Created by FreeBird on 5/31/20.
//  Copyright © 2020 Updev. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import XCDYouTubeKit
import Kingfisher

protocol VideoPlayerDelegate {
    func finishedPlay()
}

class VideoPlayer: UIViewController {
    
    var delegate:VideoPlayerDelegate?
    private var playerLayer = AVPlayerLayer()
    var player = AVPlayer()
    let playerVC = AVPlayerViewController()
    var keyWindow  = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        
    let previewVideo:UIImageView = {
        let iv = UIImageView(psEnabled: false)
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        return iv
        
    }()
    
    let progressBar = UIActivityIndicatorView()
    
    var isPlay:Bool = false{
        didSet{
            if isPlay{
                 player.play()
            }else{
                 player.pause()
            }
        }
    }
    var urlString:String?{
        didSet{
            if let url = urlString{
                if let id = getYoutubeId(youtubeUrl: url), !id.isEmpty{
                    getParseURL(id: id)
                }else{
                    videoLink = URL(string: urlString ?? "")
                }
            }
        }
        
    }
    
  var videoLink:URL?{
        didSet{
           // progressBar.stopAnimating()
            
            if let url = videoLink
            {
                if isYouTub{
                    player = AVPlayer(url: url)
                    playerLayer = AVPlayerLayer(player: player)
                    playerLayer.videoGravity = .resizeAspectFill
                    view.layer.addSublayer(playerLayer)
                   // player.play()
                   // removeSpinnerView()
                }else{
                    
                    player = AVPlayer(url: url)
                    playerLayer = AVPlayerLayer(player: player)
                    playerLayer.videoGravity = .resizeAspectFill
                    playerVC.player = player
                    captureSomeImage(url: url)
                }
            }else{

            }
        }
   }
    
    var isYouTub:Bool = false
    var generator:ACThumbnailGenerator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerLayer.frame = view.frame
        createSpinnerView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fileComplete),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil)
        playerVC.delegate = self
    }
    
    func createSpinnerView() {
        
        addChild(GymIndicator.shared)
        GymIndicator.shared.view.frame = CGRect(x: view.bounds.width/2 - 15,y: view.bounds.width/2 - 15, width: 30, height: 30)
        view.addSubview(GymIndicator.shared.view)
        GymIndicator.shared.didMove(toParent: self)
        
        // wait two seconds to simulate some work happening
    }
    
    func removeSpinnerView(){
        DispatchQueue.main.async {
             GymIndicator.shared.willMove(toParent: nil)
             GymIndicator.shared.view.removeFromSuperview()
             GymIndicator.shared.removeFromParent()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
             // then remove the spinner view controller
            GymIndicator.shared.willMove(toParent: nil)
            GymIndicator.shared.view.removeFromSuperview()
            GymIndicator.shared.removeFromParent()
         }
    }
    @objc func fileComplete() {
        delegate?.finishedPlay()
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           playerLayer.frame = view.bounds
       }

    @objc func playVideo(){
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        let vc = keyWindow?.rootViewController
        vc!.present(playerVC, animated: true) {
            self.playerVC.player?.play()
        }
    }
    
    @objc func fullScreen(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        playerVC.player = player
        player.pause()
        let vc = keyWindow?.rootViewController
        vc!.present(playerVC, animated: true) {
            self.playerVC.player?.play()
        }
    }

    func getParseURL(id:String){
    
        XCDYouTubeClient.default().getVideoWithIdentifier(id) { (video, err) in
            if err != nil {
                print("okay")
                self.isYouTub = false
            }else{
                self.isYouTub = true
                //let url = video?.thumbnailURLs?.last
                //self.previewVideo.kf.setImage(with: url)
                self.videoLink = video?.streamURL
            }
        }
        
    }
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        guard let id = youtubeUrl.split(separator: "/").last else{
            return nil
        }
        return String(id)//URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        playerLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.height
            , height: view.bounds.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

}

extension VideoPlayer:ACThumbnailGeneratorDelegate{
    
    func generator(_ generator: ACThumbnailGenerator, didCapture image: UIImage, at position: Double) {
        previewVideo.image = image
    }
    
    func captureSomeImage(url:URL) {
        generator = ACThumbnailGenerator(streamUrl: url)
        generator.delegate = self
        generator.captureImage(at: 300)
    }
    
}

extension VideoPlayer:AVPlayerViewControllerDelegate{
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.player.play()
    }
}
extension AVPlayerViewController{
    open override func viewWillDisappear(_ animated: Bool) {
        
        self.player?.pause()
       
    }
}


class GymIndicator: UIViewController {
    static let shared = GymIndicator()
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.backgroundColor = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
