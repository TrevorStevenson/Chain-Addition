//
//  ViewController.swift
//  Chain Addition
//
//  Created by Trevor Stevenson on 12/20/14.
//  Copyright (c) 2014 NCUnited. All rights reserved.
//

import UIKit
import iAd
import GameKit

class ViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate {

    var localPlayer = GKLocalPlayer()
    var gameCenterEnabled: Bool = false
    var leaderBoardIdentifier: String = "highScore"
    var adTimer = Timer()
    
    @IBOutlet weak var freePointsButton: UIButton!
    
    @IBOutlet weak var adBanner: ADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        authenticateLocalPlayer()
    }
    
    func authenticateLocalPlayer()
    {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController: UIViewController?, error: Error?) in
            
            if let VC = viewController { self.present(VC, animated: true, completion: nil) }
            else
            {
                guard localPlayer.isAuthenticated else { return }
                
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler:nil)
            }
        }
    }
    
    func showLeaderboard(withIdentifier identifier: String)
    {
        let GKVC = GKGameCenterViewController()
        GKVC.gameCenterDelegate = self
        GKVC.viewState = GKGameCenterViewControllerState.leaderboards
        GKVC.leaderboardIdentifier = identifier
        
        present(GKVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func leaderboard(_ sender: AnyObject)
    {
        showLeaderboard(withIdentifier: leaderBoardIdentifier)
    }

    @IBAction func twitter(_ sender: AnyObject)
    {
        let twitterURL = URL(string: "twitter://user?screen_name=TStevensonApps")
        
        if (UIApplication.shared.canOpenURL(twitterURL!))
        {
            UIApplication.shared.openURL(twitterURL!)
        }
        else
        {
            UIApplication.shared.openURL(URL(fileURLWithPath: "www.twitter.com/TStevensonApps"))
        }
    }
   
}

